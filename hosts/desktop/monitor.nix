{ pkgs, ... }:

{
  # Set the wallpaper
  home.file.".background-image".source = ../../assets/wallpaper.png;

  # Desktop monitor configuration
  xsession.initExtra = ''
    # Set resolution for XMonad (Primary monitor 4K @ 119.88Hz)
    # Dynamically detects the first connected monitor
    MONITOR=$(${pkgs.xorg.xrandr}/bin/xrandr | ${pkgs.gnugrep}/bin/grep " connected" | ${pkgs.coreutils}/bin/head -n 1 | ${pkgs.coreutils}/bin/cut -d " " -f1)
    ${pkgs.xorg.xrandr}/bin/xrandr --output "$MONITOR" --mode 3840x2160 --rate 119.88 --dpi 96

    # Set background
    ${pkgs.feh}/bin/feh --bg-fill ~/.background-image

    # Fix cursor on root window
    ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr

    # Initialize betterlockscreen cache
    ${pkgs.betterlockscreen}/bin/betterlockscreen -u ~/.background-image
  '';
}