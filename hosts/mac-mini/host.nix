{ config, ... }:

{
  # Mac Mini specific host configuration
  networking.hostName = "vachicorne-mac-mini";
  nixpkgs.config.allowUnfree = true;

  # Define the primary user (needed for home-manager integration)
  users.users.${config.var.username} = {
    home = "/Users/${config.var.username}";
  };
  
  # macOS specific settings
  system.defaults = {
    dock = {
      autohide = false;
      orientation = "bottom";
      showhidden = true;
      mineffect = "genie";
      launchanim = true;
      show-process-indicators = true;
      tilesize = 48;
      static-only = true;
      mru-spaces = false;
    };

    spaces = {
      spans-displays = false;
    };
    
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXEnableExtensionChangeWarning = false;
      _FXShowPosixPathInTitle = true;
    };
    
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 14;
      KeyRepeat = 1;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };
  };
  
  # Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # State version for nix-darwin
  system.stateVersion = 6;

  # Primary user (required for homebrew, system.defaults, etc.)
  system.primaryUser = config.var.username;
  
  # Homebrew integration for packages not available in Nix
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    
    taps = [
    ];
    
    brews = [
      # Add any Mac-specific brews here if needed
    ];
    
    casks = [
      "raycast"
      "arc"
      "discord"
      "spotify"
      "1password"
      "obsidian"
      "visual-studio-code"
      "ghostty"
    ];
  };
}