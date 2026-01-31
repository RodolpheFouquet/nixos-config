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
    emacs = pkgs.emacs-pgtk;
  };

  services.emacs = {
    enable = true;
    client.enable = true;
    defaultEditor = true;
  };
}
