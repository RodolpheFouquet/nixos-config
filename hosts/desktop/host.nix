{ inputs, ... }:

{
  # Desktop-specific host configuration
  networking.hostName = "vachicorne-desktop";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
