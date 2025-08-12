{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.doom-emacs.homeManagerModules.default
  ];

  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom.d;
  };

  services.emacs = {
    enable = true;
    client.enable = true;
    defaultEditor = true;
  };
}