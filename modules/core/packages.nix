{
  lib,
  config,
  pkgs,
  inputs,
  systemType ? null,
  ...
}:

lib.optionalAttrs (systemType == "nixos") {
  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps-launcher
    (pkgs.mumble.override { pulseSupport = true; })
    restic
    cifs-utils
    samba
    cider
  ];
}
