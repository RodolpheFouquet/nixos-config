{...}:{
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

}
