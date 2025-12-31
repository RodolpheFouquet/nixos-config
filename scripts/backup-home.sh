#!/usr/bin/env bash

# Home Directory Backup Script to TrueNAS
# Usage: backup-home.sh [--dry-run]

set -euo pipefail

# Configuration - Edit these values for your TrueNAS setup
TRUENAS_HOST="${TRUENAS_HOST:-truenas.local}"
TRUENAS_USER="${TRUENAS_USER:-backup}"
TRUENAS_PORT="${TRUENAS_PORT:-22}"
BACKUP_PATH="${BACKUP_PATH:-/mnt/tank/backups/vachicorne-desktop}"
SOURCE_DIR="/home/vachicorne"
LOG_FILE="/var/log/home-backup.log"

# SSH connection string
SSH_TARGET="${TRUENAS_USER}@${TRUENAS_HOST}"

# Rsync options
RSYNC_OPTS=(
    --archive                    # Archive mode (recursive, preserve permissions, etc.)
    --verbose                    # Verbose output
    --human-readable            # Human readable numbers
    --progress                  # Show progress
    --partial                   # Keep partial files
    --inplace                   # Update files in place
    --compress                  # Compress during transfer
    --delete                    # Delete files that don't exist in source
    --delete-excluded           # Delete excluded files from destination
    --ssh="ssh -p ${TRUENAS_PORT} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
)

# Exclusions - Add patterns for files/dirs to exclude
EXCLUSIONS=(
    # Cache directories
    ".cache/*"
    ".mozilla/firefox/*/storage"
    ".mozilla/firefox/*/datareporting"
    ".local/share/Trash/*"
    ".local/share/baloo/*"
    ".local/share/akonadi/*"
    
    # Development caches
    "node_modules"
    ".npm"
    ".cargo/registry"
    ".cargo/git"
    "target/"
    ".next/"
    "dist/"
    "build/"
    
    # Container/VM files
    ".local/share/containers/*"
    ".local/share/podman/*"
    "VirtualBox VMs/*"
    ".vagrant.d/*"
    
    # Temporary files
    "*.tmp"
    "*.temp"
    "*.swp"
    "*.swo"
    "*~"
    
    # Large media caches
    ".local/share/Steam/steamapps/common/*"
    ".steam/*"
    ".minecraft/*"
    
    # Browser caches
    ".config/google-chrome/Default/Application Cache/*"
    ".config/chromium/Default/Application Cache/*"
    ".config/BraveSoftware/Brave-Browser/Default/Application Cache/*"
    
    # IDE caches
    ".vscode/extensions/*"
    ".local/share/JetBrains/*"
    
    # System directories that shouldn't be backed up
    ".gvfs"
    ".dbus"
    ".pulse*"
    
    # Log files
    "*.log"
    ".local/share/xorg/*"
    
    # Package manager caches
    ".local/share/flatpak/*"
    
    # Thumbnails and previews
    ".thumbnails/*"
    ".local/share/recently-used.xbel"
)

# Build exclude arguments
EXCLUDE_ARGS=()
for exclusion in "${EXCLUSIONS[@]}"; do
    EXCLUDE_ARGS+=(--exclude="$exclusion")
done

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Function to check if TrueNAS is reachable
check_connectivity() {
    log "Checking connectivity to ${SSH_TARGET}..."
    if ! ssh -p "${TRUENAS_PORT}" -o ConnectTimeout=10 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${SSH_TARGET}" "echo 'Connection successful'" &>/dev/null; then
        log "ERROR: Cannot connect to TrueNAS server ${SSH_TARGET}"
        log "Please ensure:"
        log "  1. TrueNAS SSH service is running"
        log "  2. SSH keys are set up correctly"
        log "  3. Network connectivity is available"
        log "  4. Host/port/user are correct"
        exit 1
    fi
    log "Connection successful!"
}

# Function to create backup directory on TrueNAS
create_backup_dir() {
    log "Creating backup directory on TrueNAS..."
    ssh -p "${TRUENAS_PORT}" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${SSH_TARGET}" \
        "mkdir -p '${BACKUP_PATH}'" || {
        log "ERROR: Failed to create backup directory ${BACKUP_PATH}"
        exit 1
    }
}

# Function to perform backup
perform_backup() {
    local dry_run_flag=""
    if [[ "${1:-}" == "--dry-run" ]]; then
        dry_run_flag="--dry-run"
        log "Performing DRY RUN - no files will be transferred"
    else
        log "Starting backup of ${SOURCE_DIR} to ${SSH_TARGET}:${BACKUP_PATH}"
    fi
    
    # Add timestamp to log
    log "Backup started at $(date)"
    
    # Perform rsync
    if rsync "${RSYNC_OPTS[@]}" "${EXCLUDE_ARGS[@]}" ${dry_run_flag} \
        "${SOURCE_DIR}/" "${SSH_TARGET}:${BACKUP_PATH}/"; then
        log "Backup completed successfully!"
    else
        log "ERROR: Backup failed with exit code $?"
        exit 1
    fi
    
    # Log completion
    log "Backup finished at $(date)"
}

# Function to show backup size
show_backup_info() {
    log "Getting backup information..."
    ssh -p "${TRUENAS_PORT}" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${SSH_TARGET}" \
        "du -sh '${BACKUP_PATH}' 2>/dev/null || echo 'Backup directory size: Unknown'"
}

# Main execution
main() {
    log "=== Home Directory Backup Script ==="
    log "Source: ${SOURCE_DIR}"
    log "Target: ${SSH_TARGET}:${BACKUP_PATH}"
    
    check_connectivity
    create_backup_dir
    perform_backup "$@"
    show_backup_info
    
    log "=== Backup Complete ==="
}

# Run main function with all arguments
main "$@"