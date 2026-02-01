{ config, inputs, pkgs, lib, ... }:
{
  home-manager.users.${config.var.username} = { inputs, pkgs, lib, config, ... }: {
    imports = [
      inputs.doom-emacs-unstraightened.hmModule
    ];

    programs.doom-emacs = {
      enable = true;
      doomDir = ./doom.d;
      emacs = if pkgs.stdenv.isLinux then pkgs.emacs-pgtk else pkgs.emacs;
    };

    services.emacs = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      client.enable = true;
      defaultEditor = true;
    };
  };
}