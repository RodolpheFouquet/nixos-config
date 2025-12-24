{ ... }:

{
  # Mac Mini specific host configuration
  networking.hostName = "vachicorne-mac-mini";
  
  # macOS specific settings
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
      showhidden = true;
      mineffect = "genie";
      launchanim = true;
      show-process-indicators = true;
      tilesize = 48;
      static-only = true;
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
  security.pam.enableSudoTouchIdAuth = true;
  
  # Auto upgrade the nix package and the daemon service
  services.nix-daemon.enable = true;
  
  # Homebrew integration for packages not available in Nix
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    
    taps = [
      "homebrew/services"
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
    ];
  };
}