{ inputs, config, pkgs, ... }:

{
  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland.enable = true; # enable Hyprland
  home.sessionVariables.NIXOS_OZONE_WL = "1";


  imports = [ 
      ./hyprland
  ];
   # Your home-manager configuration here
  home.packages = with pkgs; [
    vscode  # This will now be able to install unfree packages
    gh
    discord
    wezterm
    google-chrome
    git
    wget
    pavucontrol
    neovim
    wofi
    fzf
    ripgrep
    nodejs_24
    go
    ocaml
    ocamlPackages.findlib
    ocamlPackages.ocaml-lsp
    ocamlPackages.batteries
    opam
    killall
    ghostty
    gnumake
    gcc15
    font-awesome
    zig
    fastfetch
    waybar
  ];
}
