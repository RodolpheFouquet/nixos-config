{ ... }:

{
  # Desktop-specific host configuration
  networking.hostName = "vachicorne-desktop";

  # BTRFS autoscrub configuration
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
    interval = "monthly";
  };
}