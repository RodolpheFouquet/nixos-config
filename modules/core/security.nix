{
  lib,
  config,
  pkgs,
  systemType ? null,
  ...
}:

lib.optionalAttrs (systemType == "nixos") {
  security.sudo.wheelNeedsPassword = true;
  security.polkit.enable = true;
}
