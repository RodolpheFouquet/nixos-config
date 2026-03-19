{
  lib,
  config,
  pkgs,
  ...
}:

lib.optionalAttrs (systemType == "nixos") {
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [
    "ip_tables"
    "iptable_nat"
  ];
  boot.supportedFilesystems = [
    "exfat"
    "ntfs"
  ];
  boot.kernelParams = [ "nvidia-drm.fbdev=1" ];

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
    "armv7l-linux"
  ];

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.ipv4.tcp_syncookies" = 1;

    "kernel.dmesg_restrict" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.yama.ptrace_scope" = 1;
  };

  boot.tmp.cleanOnBoot = true;
}
