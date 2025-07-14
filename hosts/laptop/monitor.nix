{ ... }:

{
  # Laptop monitor configuration
  wayland.windowManager.hyprland.settings = {
    monitor = [
      # Laptop display - 2560x1440
      "eDP-1, 2560x1440@60,0x0,1"
      # Add external monitor support
      ", preferred, auto, 1"
    ];
  };
}