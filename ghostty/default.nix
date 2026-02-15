{
  config,
  pkgs,
  lib,
  ...
}:
{
  home-manager.users.${config.var.username} = lib.mkIf pkgs.stdenv.isLinux (
    { pkgs, ... }:
    {
      xdg.configFile."ghostty/config".text = ''
        font-family = "FiraCode Nerd Font"
        font-size = 11
        theme = TokyoNight
        window-padding-x = 10
        window-padding-y = 10
        window-decoration = false
        gtk-tabs-location = hidden
        command = ${pkgs.fish}/bin/fish
      '';
    }
  );
}
