{ inputs, config, pkgs, ... }:

{
  imports = [
      ./packages
      ./hyprland
      ./neovim
  ];
}
