{ config, pkgs, lib, ... }:
{
  home-manager.users.${config.var.username} = lib.mkIf pkgs.stdenv.isLinux ({ pkgs, ... }: {
    xdg.configFile."ghostty/config".text = ''
      theme = tokyonight
      font-family = "FiraCode Nerd Font"
      font-size = 11
      window-padding-x = 10
      window-padding-y = 10
      command = ${pkgs.fish}/bin/fish
    '';
  });
}
