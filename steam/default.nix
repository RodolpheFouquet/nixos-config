{ pkgs, ... }:{
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

  hardware.xone.enable = true;
  
  environment.systemPackages = with pkgs; [
    gamemode
    gamescope
    mangohud
  ];

}
