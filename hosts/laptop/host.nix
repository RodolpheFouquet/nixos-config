# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,lib, ... }:
let
  mt7902_wm = pkgs.fetchurl {
    url = "https://github.com/ArynKumr/mt7902driverforlinux/raw/main/WIFI_RAM_CODE_MT7902_1.bin";
    sha256 = "0awlgbky404wzf916l1bzvrsj6avya8vqfzk990ywi8d2dr9k4dr"; # SEE NOTE BELOW
  };

  mt7902_rom = pkgs.fetchurl {
    url = "https://github.com/ArynKumr/mt7902driverforlinux/raw/main/WIFI_MT7902_patch_mcu_1_1_hdr.bin";
    sha256 = "09gnzyq7k1n5vbsb112flrzajny8d28g3jdvm1ids62k4bpd0cqi";
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./monitor.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptopnul"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [22];

  # Configure laptop lid behavior - suspend when lid is closed
  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchDocked = "suspend";

  services.openssh = {
    enable = true;
    ports = [22];

    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };

  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vachicorne = {
    isNormalUser = true;
    description = "vachicorne";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    neovim
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
  
  # 2. Add the firmware (Corrected direct copy)
  hardware.firmware = [
    (pkgs.runCommand "mt7902-firmware" {} ''
      mkdir -p $out/lib/firmware/mediatek
      cp ${mt7902_wm} $out/lib/firmware/mediatek/mt7902_wm.bin
      cp ${mt7902_rom} $out/lib/firmware/mediatek/mt7902_rom_patch.bin
    '')
  ];


  # 4. Optional: If the card still isn't seen, we force the ID 
  # This tells the mt7921e driver to handle the mt7902 hardware ID (14c3:7902)
  boot.extraModprobeConfig = ''
    install mt7921e /run/current-system/sw/bin/modprobe --ignore-install mt7921e; /run/current-system/sw/bin/modprobe --ignore-install mt7921e; echo "14c3 7902" > /sys/bus/pci/drivers/mt7921e/new_id
  '';

  boot.kernelModules = [ "mt7921e" ];


}
