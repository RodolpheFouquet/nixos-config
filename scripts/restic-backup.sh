#!/usr/bin/env bash

# Restic Home Directory Backup Script
# Backs up entire home directory to TrueNAS SMB share using Restic

set -euo pipefail

# Configuration
BACKUP_MOUNT="/mnt/truenas_backup"
RESTIC_REPOSITORY="${BACKUP_MOUNT}/restic-backups/vachicorne-desktop"
SOURCE_DIR="/home/vachicorne"
RESTIC_PASSWORD_FILE="/var/lib/backup-secrets/restic-password"
LOG_FILE="/var/log/restic-backup.log"

# Restic environment
export RESTIC_REPOSITORY
export RESTIC_PASSWORD_FILE

# Exclusion patterns
EXCLUDE_FILE="/tmp/restic-excludes"

# Create exclude file
cat > "$EXCLUDE_FILE" << 'EOF'
# Cache directories
.cache
.mozilla/firefox/*/storage
.mozilla/firefox/*/datareporting
.local/share/Trash
.local/share/baloo
.local/share/akonadi

# Development build artifacts
node_modules
.npm
.cargo/registry
.cargo/git
target/
.next/
dist/
build/

# Container and virtualization
.local/share/containers
.local/share/podman
VirtualBox VMs
.vagrant.d

# Temporary files
*.tmp
*.temp
*.swp
*.swo
*~

# Large application data
.local/share/Steam/steamapps/common
.steam
.minecraft

# Browser caches
.config/google-chrome/Default/Application Cache
.config/chromium/Default/Application Cache
.config/BraveSoftware/Brave-Browser/Default/Application Cache

# IDE caches
.vscode/extensions
.local/share/JetBrains

# System files
.gvfs
.dbus
.pulse*

# Log files
*.log
.local/share/xorg

# Thumbnails
.thumbnails
.local/share/recently-used.xbel

# Package manager caches
.local/share/flatpak
EOF

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Check if backup mount is available
check_mount() {
    log "Checking if TrueNAS backup mount is available..."
    
    # Create mount point if it doesn't exist
    sudo mkdir -p "$BACKUP_MOUNT"
    
    # Try to access the mount (will auto-mount due to systemd.automount)
    if ! timeout 30 ls "$BACKUP_MOUNT" >/dev/null 2>&1; then
        log "ERROR: Cannot access TrueNAS backup share at $BACKUP_MOUNT"
        log "Please check:"
        log "  1. SMB credentials in /etc/nixos/smb-credentials"
        log "  2. Network connectivity to 192.168.1.27"
        log "  3. SMB share permissions"
        exit 1
    fi
    
    log "TrueNAS backup mount is accessible"
}

# Initialize restic repository if it doesn't exist
init_repository() {
    if ! restic snapshots >/dev/null 2>&1; then
        log "Initializing new Restic repository..."
        mkdir -p "$(dirname "$RESTIC_REPOSITORY")"
        restic init
        log "Repository initialized successfully"
    else
        log "Using existing Restic repository"
    fi
}

# Perform backup
perform_backup() {
    log "Starting backup of $SOURCE_DIR"
    log "Repository: $RESTIC_REPOSITORY"
    
    # Create backup with tags
    if restic backup "$SOURCE_DIR" \
        --exclude-file="$EXCLUDE_FILE" \
        --tag "home-backup" \
        --tag "$(hostname)" \
        --verbose; then
        log "Backup completed successfully"
    else
        log "ERROR: Backup failed with exit code $?"
        exit 1
    fi
}

# Cleanup old snapshots (keep daily for 7 days, weekly for 4 weeks, monthly for 6 months)
cleanup_snapshots() {
    log "Cleaning up old snapshots..."
    if restic forget \
        --keep-daily 7 \
        --keep-weekly 4 \
        --keep-monthly 6 \
        --tag "home-backup" \
        --prune; then
        log "Cleanup completed successfully"
    else
        log "WARNING: Cleanup failed with exit code $?"
    fi
}

# Show repository statistics
show_stats() {
    log "Repository statistics:"
    restic stats --mode restore-size | tee -a "$LOG_FILE"
    
    log "Recent snapshots:"
    restic snapshots --last 5 | tee -a "$LOG_FILE"
}

# Main execution
main() {
    log "=== Restic Home Backup Started ==="
    
    check_mount
    init_repository
    perform_backup
    cleanup_snapshots
    show_stats
    
    log "=== Restic Home Backup Completed ==="
    
    # Clean up exclude file
    rm -f "$EXCLUDE_FILE"
}

# Handle dry-run
if [[ "${1:-}" == "--dry-run" ]]; then
    log "DRY RUN - would backup $SOURCE_DIR to $RESTIC_REPOSITORY"
    check_mount
    init_repository
    restic backup "$SOURCE_DIR" --exclude-file="$EXCLUDE_FILE" --dry-run --verbose
    rm -f "$EXCLUDE_FILE"
else
    main "$@"
fi