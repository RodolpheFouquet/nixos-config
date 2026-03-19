{
  lib,
  config,
  pkgs,
  systemType ? null,
  ...
}:

lib.optionalAttrs (systemType == "nixos") {
  security.rtkit.enable = true;

  services.hardware.openrgb.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.upower.enable = true;
  services.tuned.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  programs.dsearch = {
    enable = true;
    systemd = {
      enable = true;
      target = "default.target";
    };
  };

  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };

  services.flatpak.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  networking.firewall.enable = false;

  powerManagement.cpuFreqGovernor = "performance";
  services.irqbalance.enable = true;

  boot.kernel.sysctl."vm.max_map_count" = 2147483642;

  environment.etc."xdg/applications/yazi-terminal.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Yazi File Manager
    Comment=Blazing fast terminal file manager
    Exec=ghostty -e yazi %f
    Icon=folder
    Terminal=false
    MimeType=inode/directory;
    Categories=System;FileTools;FileManager;
  '';

  programs.starship.enable = true;
}
