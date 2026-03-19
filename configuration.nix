{
  config,
  pkgs,
  lib,
  systemType ? null,
  ...
}:

{
  imports = lib.optionals (systemType == "nixos") [
    ./modules/core/nix.nix
    ./modules/core/boot.nix
    ./modules/core/networking.nix
    ./modules/core/user.nix
    ./modules/core/localization.nix
    ./modules/core/security.nix
    ./modules/core/packages.nix
    ./modules/desktop/plasma.nix
    ./modules/services/general.nix
    ./modules/services/printing.nix
    ./modules/services/filesystems.nix
    ./modules/services/backup.nix
  ];

  config = lib.optionalAttrs (systemType == "nixos") {
    system.stateVersion = "25.11";
  };
}
