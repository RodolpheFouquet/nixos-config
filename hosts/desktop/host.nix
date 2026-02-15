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

  # Monitor hotplug management (X11)
  services.autorandr.enable = true;

  imports = [
    ../../modules/services/backup.nix
  ];

  # BTRFS autoscrub configuration
  # services.btrfs.autoScrub = {
  #   enable = true;
  #   fileSystems = [ "/" ];
  #   interval = "monthly";
  # };

}
