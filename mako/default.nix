{
  ...
}:
{
  services.mako = {
    enable = true;
    
    settings = {
      # Position notifications in top right
      anchor = "top-right";
      
      # Gruvbox dark theme colors
      background-color = "#282828";
      text-color = "#ebdbb2";
      border-color = "#458588";
      progress-color = "#83a598";
      
      # Notification appearance
      width = 400;
      height = 150;
      padding = "15";
      margin = "10";
      border-radius = 8;
      border-size = 2;
      
      # Timeout (3 seconds = 3000ms)
      default-timeout = 3000;
      
      # Font
      font = "JetBrains Mono 11";
      
      # Advanced styling
      layer = "overlay";
      markup = true;
      max-visible = 5;
      sort = "-time";
      
      # Icon settings
      icon-path = "/run/current-system/sw/share/icons/Adwaita";
      max-icon-size = 48;
    };
  };
}