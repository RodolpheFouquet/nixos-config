{ lib }:
let
  userModules = [
    "neovim"
    "tmux"
    "git"
    "fastfetch"
    "ghostty"
    "xmonad"
    "emacs"
    "steam"
    "virtualization"
    "display"
    "noctalia"
  ];
in
let
  recursiveFind =
    dir:
    let
      entries = builtins.readDir dir;

      filterPath =
        name: type:
        let
          isNix = lib.hasSuffix ".nix" name;
          isDir = type == "directory";
          isHostFile = name == "host.nix";
          isMonitorFile = name == "monitor.nix";
          isHomeFile = name == "home.nix" || name == "home-darwin.nix";
          isExcludedModule = lib.elem name userModules;
        in
        (isNix || isDir)
        && !isHostFile
        && !isMonitorFile
        && !isHomeFile
        && !isExcludedModule
        && name != "flake.nix"
        && name != "flake.lock"
        && name != "mac-flake.nix"
        && name != ".git"
        && name != "hosts"
        && name != "lib"
        && name != "packages"
        && name != ".claude";

      filteredEntries = lib.filterAttrs filterPath entries;

      paths = lib.mapAttrsToList (
        name: type:
        let
          path = dir + "/${name}";
        in
        if type == "directory" then recursiveFind path else [ path ]
      ) filteredEntries;

    in
    lib.flatten paths;

  dendritic =
    dir:
    let
      files = recursiveFind dir;
    in
    files;
in
dendritic
