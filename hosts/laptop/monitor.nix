{ pkgs, ... }:

{
  # Set the wallpaper
  home.file.".background-image".source = ../../assets/wallpaper.png;

  # Laptop monitor configuration
  xsession.initExtra = ''
    # Set resolution for XMonad (Laptop 1080p)
    # Dynamically detects the first connected monitor
    MONITOR=$(${pkgs.xorg.xrandr}/bin/xrandr | ${pkgs.gnugrep}/bin/grep " connected" | ${pkgs.coreutils}/bin/head -n 1 | ${pkgs.coreutils}/bin/cut -d " " -f1)
    
    # Attempt to set 1920x1080. If that fails (e.g. not supported), fallback to auto.
    ${pkgs.xorg.xrandr}/bin/xrandr --output "$MONITOR" --mode 1920x1080 --dpi 96 || ${pkgs.xorg.xrandr}/bin/xrandr --output "$MONITOR" --auto

    # Set background
    ${pkgs.feh}/bin/feh --bg-fill ~/.background-image

    # Fix cursor on root window
    ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr

    # Initialize betterlockscreen cache
    ${pkgs.betterlockscreen}/bin/betterlockscreen -u ~/.background-image
  '';
}