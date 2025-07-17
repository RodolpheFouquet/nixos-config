{ ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      # Theme
      theme = "GruvboxDark";

      # Font configuration
      font-family = "JetBrains Mono Nerd Font";
      font-size = 11;

      # Window configuration
      window-decoration = false;
      window-padding-x = 10;
      window-padding-y = 10;

      # Terminal behavior
      cursor-style = "block";
      cursor-style-blink = false;

      # Shell integration
      shell-integration = "fish";

      # Performance
      confirm-close-surface = false;

    };
  };
}

