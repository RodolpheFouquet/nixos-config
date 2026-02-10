{ lib, config, pkgs, ... }:
let
  cfg = config.var;
in
{
  options.var = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "vachicorne";
      description = "The username of the primary user";
    };
    userHome = lib.mkOption {
      type = lib.types.str;
      default = if pkgs.stdenv.isDarwin then "/Users/${cfg.username}" else "/home/${cfg.username}";
      description = "The home directory of the primary user";
    };
    desktop = lib.mkOption {
      type = lib.types.enum [ "kde" ];
      default = "kde";
      description = "The desktop environment to use";
    };
  };
}
