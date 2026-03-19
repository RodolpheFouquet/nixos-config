{ lib }:
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
        in
        (isNix || isDir)
        && !isHostFile
        && name != "flake.nix"
        && name != "flake.lock"
        && name != "mac-flake.nix"
        && name != ".git"
        && name != "lib"
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
