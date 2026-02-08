{ config, pkgs, lib, hostName, ... }:

let
  isDesktop = hostName == "vachicorne-desktop";
in
lib.mkIf pkgs.stdenv.isLinux {
  services.xserver.videoDrivers = lib.mkIf isDesktop [ "nvidia" ];
  services.xserver.enable = true;

  # Environment variables for NVIDIA Optimus
  environment.variables = lib.mkIf isDesktop {
    # Required for NVIDIA on Wayland
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Additional GPU tools
  environment.systemPackages = lib.mkIf isDesktop (with pkgs; [
    nvidia-vaapi-driver
    libva-utils
    vdpauinfo
    mesa-demos
    vulkan-tools
  ]);

  services.displayManager.dms-greeter = {
    enable = config.var.desktop == "niri";
    compositor.name = "niri"; # Or "hyprland" or "sway"
  };

  services.displayManager.sddm = {
    enable = config.var.desktop == "kde";
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = config.var.desktop == "kde";

  # NVIDIA application profiles for niri compositor optimization
  environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json" =
    lib.mkIf isDesktop {
      text = ''
        {
            "rules": [
                {
                    "pattern": {
                        "feature": "procname",
                        "matches": "niri"
                    },
                    "profile": "Limit Free Buffer Pool On Wayland Compositors"
                }
            ],
            "profiles": [
                {
                    "name": "Limit Free Buffer Pool On Wayland Compositors",
                    "settings": [
                        {
                            "key": "GLVidHeapReuseRatio",
                            "value": 0
                        }
                    ]
                }
            ]
        }
      '';
    };
}