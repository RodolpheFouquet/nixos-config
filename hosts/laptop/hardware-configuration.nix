# Example laptop hardware configuration
# Replace this with the actual hardware-configuration.nix from your laptop
# Generate with: sudo nixos-generate-config

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Example laptop hardware - replace with actual configuration
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Example filesystem configuration - replace with actual
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-UUID";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Laptop-specific hardware
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  # Laptop power management
  services.tlp.enable = true;
  powerManagement.enable = true;
}