{
  lib,
  config,
  pkgs,
  ...
}:

lib.optionalAttrs (systemType == "nixos") {
  fileSystems."${config.var.smbBackupMount}" = {
    device = config.var.smbBackupDevice;
    fsType = "cifs";
    options = [
      "noauto"
      "user"
      "uid=vachicorne"
      "gid=users"
      "iocharset=utf8"
      "file_mode=0644"
      "dir_mode=0755"
      "credentials=${config.var.smbCredentialsPath}"
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=60"
    ];
  };
}
