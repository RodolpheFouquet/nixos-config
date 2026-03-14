{ config, pkgs, lib, systemType ? null, ... }:
lib.optionalAttrs (systemType == "nixos") {
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "${config.var.username}" ];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  # Enable libguestfs for VM introspection
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  virtualisation.waydroid.enable = true;

  environment.systemPackages = with pkgs; [
    libguestfs
    libguestfs-with-appliance
    guestfs-tools
  ];
}