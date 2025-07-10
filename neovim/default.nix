{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    # Set Neovim as the default editor
    defaultEditor = true; 
    extraPackages = with pkgs; [
      wl-clipboard # For Wayland
        # or xclip    # For X11
    ];

    extraConfig = ''
      " Set hybrid line numbers
      set number
      set relativenumber

      " Disable mouse support completely
      set mouse=

      " Enable system clipboard integration
      " This allows yanking/pasting to/from the system clipboard
      set clipboard=unnamedplus
      set tabstop=2
      set shiftwidth=2
      set expandtab
    '';
  };

}
