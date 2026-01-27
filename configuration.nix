{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  vars = import ./variables.nix;
in

{
  imports = [
    inputs.dms.nixosModules.dank-material-shell
    # Hardware-specific configuration is now imported in flake.nix per host
    # Your other custom modules
    ./steam
    ./display
    ./virtualization
  ];

  # --- System Settings ---
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Dual boot configuration
  boot.loader.grub = {
    enable = false; # We're using systemd-boot, not GRUB
  };

  # Configure systemd-boot for dual boot
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.timeout = 10;

  # Add Windows boot entry
  boot.loader.systemd-boot.extraEntries."windows.conf" = ''
    title Windows 11
    efi /EFI/Microsoft/Boot/bootmgfw.efi
  '';

  # Mount Windows EFI partition to make it available
  fileSystems."/boot/windows-efi" = {
    device = "/dev/nvme1n1p1";
    fsType = "vfat";
    options = [
      "umask=0077"
      "dmask=0077"
      "fmask=0177"
      "uid=1000"
      "gid=1000"
      "nofail"
    ];
  };

  # TrueNAS SMB share mount for backups
  fileSystems."/mnt/truenas_backup" = {
    device = "//192.168.1.27/vachicorne";
    fsType = "cifs";
    options = [
      "noauto" # Don't mount at boot
      "user" # Allow user to mount
      "uid=vachicorne" # Set ownership to your user
      "gid=users" # Set group ownership
      "iocharset=utf8" # Character encoding
      "file_mode=0644" # File permissions
      "dir_mode=0755" # Directory permissions
      "credentials=/var/lib/backup-secrets/smb-credentials" # Credentials file
      "nofail" # Don't fail boot if unavailable
      "x-systemd.automount" # Auto-mount on access
      "x-systemd.idle-timeout=60" # Unmount after 60s idle
    ];
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [
    "ip_tables"
    "iptable_nat"
  ];
  boot.supportedFilesystems = [
    "exfat"
    "ntfs"
  ];

  # Enable cross compilation for ARM64 and other architectures
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
    "armv7l-linux"
  ];

  nixpkgs.config.allowUnfree = true;

  # Overlays
  nixpkgs.overlays = [
    (final: prev: {
      cider = prev.callPackage (
        {
          lib,
          appimageTools,
          requireFile,
        }:

        appimageTools.wrapType2 rec {
          pname = "cider";
          version = "3.1.8";

          src = requireFile {
            name = "cider-v${version}-linux-x64.AppImage";
            url = "https://taproom.ciderapp.sh/";
            sha256 = "1b5qllzk1r7jpxw19a90p87kpc6rh05nc8zdr22bcl630xh8ql5k";
          };

          extraInstallCommands =
            let
              contents = appimageTools.extract { inherit pname version src; };
            in
            ''
              # Find the actual binary name in the extracted contents
              if [ -f $out/bin/${pname}-${version} ]; then
                mv $out/bin/${pname}-${version} $out/bin/${pname}
              elif [ -f $out/bin/AppRun ]; then
                mv $out/bin/AppRun $out/bin/${pname}
              fi

              # Install desktop file if it exists
              if [ -f ${contents}/${pname}.desktop ]; then
                install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
                substituteInPlace $out/share/applications/${pname}.desktop \
                  --replace 'Exec=AppRun' 'Exec=${pname}'
                # Ensure Icon matches pname
                sed -i 's/^Icon=.*/Icon=${pname}/' $out/share/applications/${pname}.desktop
              fi

              # Copy icons if they exist
              if [ -d ${contents}/usr/share/icons ]; then
                cp -r ${contents}/usr/share/icons $out/share
                chmod -R u+w $out/share
              fi

              # Fallback: install icon from root if generic path didn't work or just to be safe
              if [ -f ${contents}/.DirIcon ]; then
                install -m 444 -D ${contents}/.DirIcon $out/share/icons/hicolor/512x512/apps/${pname}.png
              elif [ -f ${contents}/${pname}.png ]; then
                 install -m 444 -D ${contents}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png
              fi
            '';

          meta = with lib; {
            description = "A new look into listening and enjoying Apple Music in style and performance.";
            homepage = "https://cider.sh/";
            maintainers = [ maintainers.nicolaivds ];
            platforms = [ "x86_64-linux" ];
          };
        }
      ) { };

    })
  ];

  # --- Networking ---
  # Hostname is now set in individual host configurations
  # networking.hostName will be set per host
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Avahi for network device discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    # Core features
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableVPN = true; # VPN management widget
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableCalendarEvents = true; # Calendar integration (khal)
    enableClipboardPaste = true; # Pasting items from the clipboard (wtype)
  };
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
      "plugdev"
      "scanner"
      "lp"
      "kvm"
    ];
    shell = pkgs.fish;
  };

  # Add ~/.local/bin to PATH
  environment.variables = {
    PATH = "$PATH:/home/vachicorne/.local/bin";
  };

  # --- Services ---
  security.rtkit.enable = true;

  services.hardware.openrgb.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.upower.enable = true;
  services.tuned.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # --- Printing & Scanning ---
  # CUPS for printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      hplip
      epson-escpr
      epson-escpr2
      canon-cups-ufr2
      brlaser
      brgenml1lpr
      brgenml1cupswrapper
      # Lexmark printer drivers
      postscript-lexmark
    ];
  };

  # SANE for scanning
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      hplipWithPlugin
      sane-airscan
    ];
  };

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
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  programs.dsearch = {
    enable = true;

    systemd = {
      enable = true;
      target = "default.target";
    };
 };
  
  # Set dolphin as default file manager
  xdg.mime.defaultApplications = {
    "inode/directory" = "org.kde.dolphin.desktop";
  };

  # Create custom desktop entry for yazi in wezterm
  environment.etc."xdg/applications/yazi-terminal.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Yazi File Manager
    Comment=Blazing fast terminal file manager
    Exec=foot yazi %f
    Icon=folder
    Terminal=false
    MimeType=inode/directory;
    Categories=System;FileTools;FileManager;
  '';

  # Container support
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # Flatpak support
  services.flatpak.enable = true;

  # Declarative flatpak packages
  services.flatpak.packages = [
    "com.github.tchx84.Flatseal"
    "com.bambulab.BambuStudio"
  ];

  # For local .flatpak files, you can also use:
  # services.flatpak.packages = [
  #   { appId = "com.example.App"; origin = "flathub"; }
  #   { flatpakref = "https://example.com/app.flatpakref"; }
  # ];

  # Container networking
  #networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];
  #networking.firewall.interfaces."podman+".allowedTCPPorts = [ 53 ];
  networking.firewall.enable = false;

  # Automatic USB mounting
  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
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
    flake = "/home/vachicorne/Code/nixos-config";
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

  # Restic backup service
  systemd.services.restic-backup = {
    description = "Restic Home Directory Backup";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "/home/vachicorne/.config/nixos/scripts/restic-backup.sh";
    };
    path = with pkgs; [
      restic
      cifs-utils
      bash
      coreutils
    ];
  };

  # Restic backup timer (daily at 2 AM)
  systemd.timers.restic-backup = {
    description = "Run Restic backup daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "02:00";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };
  };

  # Set the system state version
  system.stateVersion = "25.11";
  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps-launcher
    (pkgs.mumble.override { pulseSupport = true; })
    # Backup tools
    restic
    cifs-utils
    samba
    cider

    xwayland-satellite
    niri
  ];

}
