{ config, pkgs, lib, ... }:
{
  # Enable XMonad in NixOS
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  # Configure XMonad and Xmobar via Home Manager
  home-manager.users.${config.var.username} = { pkgs, ... }: {
    
    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };

    programs.xmobar = {
      enable = true;
      extraConfig = builtins.readFile ./xmobarrc;
    };
  };
}
