{ lib }:
let
  # Recursively finds all files in a directory
  recursiveFind =
    dir:
    let
      # Get the type of the directory path (regular, directory, symlink, etc.)
      entries = builtins.readDir dir;
      
      # Filter to keep only what we want (files ending in .nix, or directories)
      # We also filter out specific files we know we don't want to import recursively
      # like flake.nix, flake.lock, .git, etc.
      filterPath = name: type:
        let
          isNix = lib.hasSuffix ".nix" name;
          isDir = type == "directory";
        in
        (isNix || isDir) &&
        name != "flake.nix" &&
        name != "flake.lock" &&
        name != ".git" &&
        name != "hosts" &&
        name != "lib" &&
        name != ".claude";

      # Filtered entries
      filteredEntries = lib.filterAttrs filterPath entries;

      # Process entries
      paths = lib.mapAttrsToList (name: type:
        let
          path = dir + "/${name}";
        in
        if type == "directory" then
          recursiveFind path
        else
          [ path ]
      ) filteredEntries;

    in
    lib.flatten paths;
    
  # The actual loader function
  dendritic = dir:
    let
      files = recursiveFind dir;
    in
    files;
in
dendritic
