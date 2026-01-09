{ pkgs, ... }:

{
  xdg.configFile."mangowc/config.toml".text = ''
    [output]
    scale = 1.0

    [input]
    keyboard_layout = "us"
    keyboard_options = "caps:escape"

    [keybindings]
    super + return = "spawn foot"
    super + r = "spawn sh -c 'pkill -x fuzzel || fuzzel'"
    super + e = "spawn dolphin"
    super + g = "spawn google-chrome-stable"
    super + d = "close_window"
    super + f = "fullscreen"
    super + shift + n = "exit"

    # Window navigation
    super + h = "focus_left"
    super + l = "focus_right"
    super + j = "focus_down"
    super + k = "focus_up"

    # Workspace switching
    super + 1 = "workspace 1"
    super + 2 = "workspace 2"
    super + 3 = "workspace 3"
    super + 4 = "workspace 4"
    super + 5 = "workspace 5"
    super + 6 = "workspace 6"

    [window]
    border_width = 2
    active_border_color = "#7aa2f7" # Tokyo Night blue
    inactive_border_color = "#1a1b26" # Tokyo Night bg
  '';
}
