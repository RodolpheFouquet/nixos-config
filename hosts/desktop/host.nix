{ inputs, ... }:

{
  # Desktop-specific host configuration
  networking.hostName = "vachicorne-desktop";

  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };

  # BTRFS autoscrub configuration
  # services.btrfs.autoScrub = {
  #   enable = true;
  #   fileSystems = [ "/" ];
  #   interval = "monthly";
  # };

}
