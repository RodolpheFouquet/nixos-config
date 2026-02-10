{
  config,
  pkgs,
  lib,
  hostName,
  ...
}:

let
  isDesktop = hostName == "vachicorne-desktop";
in
lib.mkIf pkgs.stdenv.isLinux {
  services.xserver.videoDrivers = lib.mkIf isDesktop [ "nvidia" ];
  services.xserver.enable = true;

  # Environment variables for NVIDIA Optimus
  environment.variables = lib.mkIf isDesktop {
    # Required for NVIDIA
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # Additional GPU tools
  environment.systemPackages = lib.mkIf isDesktop (
    with pkgs;
    [
      nvidia-vaapi-driver
      libva-utils
      vdpauinfo
      mesa-demos
      vulkan-tools
    ]
  );
}

