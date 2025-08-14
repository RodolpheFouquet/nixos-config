{ pkgs, ... }:
{
  services.xserver.videoDrivers = ["nvidia"];
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };
  services.xserver.enable = true;
  services.displayManager.ly.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

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
    glxinfo
    vulkan-tools
  ];
}
