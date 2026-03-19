{
  lib,
  config,
  pkgs,
  ...
}:

lib.optionalAttrs (systemType == "nixos") {
  security.sudo.wheelNeedsPassword = true;
  security.polkit.enable = true;
}
