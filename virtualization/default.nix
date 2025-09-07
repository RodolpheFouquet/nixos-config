{ pkgs, lib, ... }:
let
  vars = import ../variables.nix;
in
{
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "${vars.username}" ];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  # Enable libguestfs for VM introspection
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  
  environment.systemPackages = with pkgs; [
    libguestfs
    libguestfs-with-appliance
    guestfs-tools
  ];

  # VM Memory Manager Service
  systemd.services.vm-memory-manager = {
    description = "VM Memory Manager - Automatic memory ballooning";
    after = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.bash}/bin/bash /home/vachicorne/.config/nixos/scripts/vm-memory-manager.sh";
      Restart = "always";
      RestartSec = "10";
      User = "root";
      Group = "libvirtd";
    };
    
    environment = {
      PATH = lib.mkForce "${pkgs.libvirt}/bin:${pkgs.coreutils}/bin:${pkgs.gawk}/bin:${pkgs.gnugrep}/bin";
    };
  };

}
