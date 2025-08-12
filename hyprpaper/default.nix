{ ... }:
let
  variables = import ../variables.nix;
  wallpaper = "${variables.userHome variables.username}/.config/nixos/assets/wallpaper.png";
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ wallpaper ];
      wallpaper = [ ",${wallpaper}" ];
    };
  };
}
