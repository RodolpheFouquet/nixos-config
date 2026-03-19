{ lib, ... }:
{
  options.var = {
    hostTypes = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        desktop = "desktop";
        laptop = "laptop";
        t440p = "t440p";
        mac-mini = "mac-mini";
      };
      description = "Available host types in this configuration";
    };
    smbBackupMount = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/truenas_backup";
      description = "Mount point for SMB backup share";
    };
    smbBackupDevice = lib.mkOption {
      type = lib.types.str;
      default = "//192.168.1.27/vachicorne";
      description = "SMB device path for backup share";
    };
    smbCredentialsPath = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/backup-secrets/smb-credentials";
      description = "Path to SMB credentials file";
    };
    nixConfigPath = lib.mkOption {
      type = lib.types.str;
      default = "/Users/vachicorne/Code/nixos-config";
      description = "Path to nix configuration";
    };
  };
}
