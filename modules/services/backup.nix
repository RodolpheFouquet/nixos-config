{ config, pkgs, lib, ... }:
{
  services.restic.backups.daily = {
    initialize = true;
    repository = "/mnt/truenas_backup/restic-backups/vachicorne-desktop";
    passwordFile = "/var/lib/backup-secrets/restic-password";
    paths = [ "/home/vachicorne" ];
    
    # Prune options (using explicit arguments for clarity)
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    
    # Exclude patterns (list of strings)
    exclude = [
      ".cache"
      ".mozilla/firefox/*/storage"
      ".mozilla/firefox/*/datareporting"
      ".local/share/Trash"
      ".local/share/baloo"
      ".local/share/akonadi"
      "node_modules"
      ".npm"
      ".cargo/registry"
      ".cargo/git"
      "target/"
      ".next/"
      "dist/"
      "build/"
      ".local/share/containers"
      ".local/share/podman"
      "VirtualBox VMs"
      ".vagrant.d"
      "*.tmp"
      "*.temp"
      "*.swp"
      "*.swo"
      "*~"
      ".local/share/Steam/steamapps/common"
      ".steam"
      ".minecraft"
      ".config/google-chrome/Default/Application Cache"
      ".config/chromium/Default/Application Cache"
      ".config/BraveSoftware/Brave-Browser/Default/Application Cache"
      ".vscode/extensions"
      ".local/share/JetBrains"
      ".gvfs"
      ".dbus"
      ".pulse*"
      "*.log"
      ".local/share/xorg"
      ".thumbnails"
      ".local/share/recently-used.xbel"
      ".local/share/flatpak"
    ];
  };
}