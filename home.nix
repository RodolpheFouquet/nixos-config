{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  home-manager.users.${config.var.username} = { inputs, pkgs, hostType ? "desktop", ... }: {
    imports = [
      inputs.nixvim.homeModules.nixvim
      
      # Import host-specific monitor configuration
      # Note: We must explicitly import it because hosts/ is excluded from dendritic loader
      (./hosts + "/${hostType}/monitor.nix")
    ];

    programs.starship.enable = true;

    # Add ~/.local/bin to PATH
    home.sessionPath = [ "$HOME/.local/bin" ];

    # Configure NPM to use ~/.local as prefix (binaries go to ~/.local/bin)
    home.sessionVariables = {
      NPM_CONFIG_PREFIX = "$HOME/.local";
      DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
    };

    # Ensure ~/.local/bin exists
    systemd.user.tmpfiles.rules = [
      "d %h/.local/bin 0755 - - -"
      "d %h/.local/share/nix-doom/straight/build-30.2 0755 - - -"
    ];

    # Direnv integration
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.whitelist = {
        prefix = [ "${config.var.userHome}/Code" ];
      };
    };

    programs.fish = {
      enable = true;
      shellInit = ''
        starship init fish | source
        zoxide init fish | source
        bind \cf tms
      '';
    };
    # WinApps desktop integration
    xdg.desktopEntries.winapps = {
      name = "WinApps Manager";
      comment = "Manage Windows applications in Linux";
      exec = "winapps";
      icon = "application-x-ms-dos-executable";
      categories = [
        "System"
        "Utility"
      ];
      terminal = true;
    };

    programs.bash = {
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    qt = {
      enable = true;
      platformTheme.name = "kde";
      style.name = "breeze";
    };

    home.pointerCursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    xresources.properties = {
      "Xcursor.size" = 24;
      "Xft.dpi" = 96;
    };

    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
  };
}
