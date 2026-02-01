{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      extraPackages = with pkgs; [ mangohud ];
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = "1";
          # Enable NVIDIA offload for all Steam games
          # __NV_PRIME_RENDER_OFFLOAD = "1";
          # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        };
      };
    };
    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
    gamemode.enable = true;
  };

  # Systemd user service that auto-configures Steam shader threads
  systemd.user.services.steam-shader-config = {
    description = "Configure Steam shader preprocessing threads";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      THREADS=$(${pkgs.coreutils}/bin/nproc)
      STEAM_THREADS=$((THREADS - 4))

      # Ensure minimum of 4 threads
      if [ $STEAM_THREADS -lt 4 ]; then
        STEAM_THREADS=4
      fi

      mkdir -p ~/.steam/steam
      echo "unShaderBackgroundProcessingThreads $STEAM_THREADS" > ~/.steam/steam/steam_dev.cfg
    '';
  };

  hardware.xone.enable = true;

  environment.systemPackages = with pkgs; [
    gamemode
    gamescope
    mangohud
    protonup-ng
  ];

}