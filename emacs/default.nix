{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.doom-emacs-unstraightened.hmModule
  ];

  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom.d;
  };

  services.emacs = {
    enable = true;
    client.enable = true;
    defaultEditor = false; # Prefer Neovim as default editor for now
  };
}
