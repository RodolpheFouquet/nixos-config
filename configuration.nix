{ config, pkgs, ... }:

let
  vars = import ./variables.nix;
in

{
  imports = [
    # Hardware-specific configuration is now imported in flake.nix per host
    # Your other custom modules
    ./steam
    ./display
  ];

  # --- System Settings ---
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.config.allowUnfree = true;
  # --- Networking ---
  # Hostname is now set in individual host configurations
  # networking.hostName will be set per host
  networking.networkmanager.enable = true;
  services.avahi.enable = true;

  # --- Localization ---
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  # (Your extraLocaleSettings remains unchanged)
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
  console.keyMap = "us";

  # Udev rule for monitor hotplug detection
  services.udev.extraRules = ''
    # KVM monitor hotplug detection
    SUBSYSTEM=="drm", ACTION=="change", RUN+="${pkgs.systemd}/bin/systemd-run --user --no-block /home/vachicorne/.config/nixos/scripts/monitor-hotplug.sh"
  '';

  # --- User Definition ---
  users.users.${vars.username} = {
    isNormalUser = true;
    description = "${vars.username}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  # --- Services ---
  security.rtkit.enable = true;

  # --- Security Hardening ---
  security.sudo.wheelNeedsPassword = true;
  security.polkit.enable = true;

  # Kernel hardening
  boot.kernel.sysctl = {
    # Disable IPv6 if not needed (optional)
    # "net.ipv6.conf.all.disable_ipv6" = 1;
    # "net.ipv6.conf.default.disable_ipv6" = 1;

    # Network security
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

    # Memory protection
    "kernel.dmesg_restrict" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.yama.ptrace_scope" = 1;
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    raopOpenFirewall = true;
    # (Your Pipewire extraConfig remains unchanged)
    extraConfig.pipewire = {
      "10-airplay" = {
        "context.modules" = [
          { name = "libpipewire-module-raop-discover"; }
        ];
      };
    };
  };
  programs.fish.enable = true;

  # Container support
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # Container networking
  networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];
  networking.firewall.interfaces."podman+".allowedTCPPorts = [ 53 ];

  services.snapper = {
    configs = {
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ "vachicorne" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        NUMBER_CLEANUP = true;
        NUMBER_MIN_AGE = 1800;
        NUMBER_LIMIT = 50;
        NUMBER_LIMIT_IMPORTANT = 10;
        TIMELINE_LIMIT_HOURLY = 24;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 4;
        TIMELINE_LIMIT_MONTHLY = 3;
      };
    };
  };

  # --- System Optimizations ---
  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Automatic system updates
  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
    randomizedDelaySec = "45min";
    persistent = true;
    flake = "/home/vachicorne/.config/nixos";
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    rebootWindow = {
      lower = "01:00";
      upper = "05:00";
    };
  };

  # Optimize nix store
  nix.settings.auto-optimise-store = true;

  # Performance tweaks
  powerManagement.cpuFreqGovernor = "performance";
  services.irqbalance.enable = true;

  # Gaming optimizations
  boot.kernel.sysctl."vm.max_map_count" = 2147483642;

  # Faster boot
  boot.tmp.cleanOnBoot = true;

  # Set the system state version
  system.stateVersion = "25.05";
}
