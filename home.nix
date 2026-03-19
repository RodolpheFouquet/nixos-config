{
  inputs,
  config,
  pkgs,
  lib,
  hostType ? "desktop",
  ...
}:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./packages/shared.nix
    (./hosts + "/${hostType}/monitor.nix")
  ];

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.local";
    DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
  };

  systemd.user.tmpfiles.rules = [
    "d %h/.local/bin 0755 - - -"
    "d %h/.local/share/nix-doom/straight/build-30.2 0755 - - -"
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.whitelist = {
      prefix = [ "${config.var.userHome}/Code" ];
    };
  };

  programs.fish = {
    enable = true;
    shellInit = lib.optionalString isLinux ''
      starship init fish | source
      zoxide init fish | source
      bind \cf tms
    '';
  };

  home.packages = with pkgs; [ appimage-run ];

  xdg.desktopEntries.cider = lib.mkIf isLinux {
    name = "Cider";
    comment = "Apple Music client";
    exec = "${pkgs.appimage-run}/bin/appimage-run ${config.var.userHome}/.local/bin/cider.AppImage";
    icon = "cider";
    categories = [
      "AudioVideo"
      "Audio"
      "Music"
      "Player"
    ];
    terminal = false;
  };

  programs.bash = {
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  home.pointerCursor = lib.mkIf isLinux {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  xresources.properties = lib.mkIf isLinux {
    "Xcursor.size" = 24;
    "Xft.dpi" = 96;
  };

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
