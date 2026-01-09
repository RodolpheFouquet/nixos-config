{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };
  services.xserver.enable = true;
  services.displayManager.ly.enable = true;

  # Environment variables for NVIDIA Optimus
  environment.variables = {
    # Required for NVIDIA on Wayland
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Additional GPU tools
  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver
    libva-utils
    vdpauinfo
    mesa-demos
    vulkan-tools
  ];

  # NVIDIA application profiles for niri compositor optimization
  environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text =
    ''
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
}
