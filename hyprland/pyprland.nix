{ pkgs, ... }:

{
  home.packages = with pkgs; [ pyprland ];
  
  # Pyprland configuration for enhanced Hyprland functionality
  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = ["scratchpads", "magnify", "workspaces_follow_focus"]

    [scratchpads.term]
    animation = "fromTop"
    command = "ghostty --class=scratchpad-term"
    class = "scratchpad-term"
    size = "75% 60%"
    max_size = "1920px 100%"
    margin = 50

    [scratchpads.files]
    animation = "fromTop" 
    command = "ghostty --class=scratchpad-files -e ranger"
    class = "scratchpad-files"
    size = "75% 60%"
    max_size = "1920px 100%"
    margin = 50

    [scratchpads.music]
    animation = "fromRight"
    command = "ghostty --class=scratchpad-music -e ncmpcpp"
    class = "scratchpad-music"
    size = "45% 85%"
    max_size = "1080px 100%"
    margin = 50

    [workspaces_follow_focus]
    max_workspaces = 10
  '';
}