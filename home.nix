{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim

    ./packages
    ./hyprland
    ./neovim
    ./tmux
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
