{ pkgs, ... }:

{
  home.packages = with pkgs; [ pyprland ];

  # Pyprland configuration for enhanced Hyprland functionality
  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = ["scratchpads", "magnify", "workspaces_follow_focus"]

    [scratchpads.term]
    animation = "fromTop"
    command = "ghostty --title=scratchpad-term"
    title = "scratchpad-term"
    match_by = "title"
    size = "75% 60%"
    max_size = "1920px 100%"
    margin = 50

    [scratchpads.files]
    animation = "fromTop" 
    command = "ghostty --title=scratchpad-files -e yazi"
    title = "scratchpad-files"
    match_by = "title"
    size = "75% 60%"
    max_size = "1920px 100%"
    margin = 50

    [scratchpads.music]
    animation = "fromRight"
    command = "ghostty --title=scratchpad-music -e ncmpcpp"
    title = "scratchpad-music"
    match_by = "title"
    size = "45% 85%"
    max_size = "1080px 100%"
    margin = 50

    [workspaces_follow_focus]
    max_workspaces = 10
  '';
}

