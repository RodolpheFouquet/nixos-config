#!/usr/bin/env bash

# Monitor hotplug detection script for KVM switching
# This script detects when the monitor is reconnected and restores the correct resolution

# Configuration
MONITOR_NAME="DP-6"
PREFERRED_RESOLUTION="5120x1440@240"
POSITION="0x0"
SCALE="1"
LOG_FILE="/tmp/monitor-hotplug.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to restore monitor configuration
restore_monitor_config() {
    log_message "Restoring monitor configuration for $MONITOR_NAME"
    
    # Wait a moment for the display to stabilize
    sleep 2
    
    # Set the monitor configuration using hyprctl
    hyprctl keyword monitor "$MONITOR_NAME,$PREFERRED_RESOLUTION,$POSITION,$SCALE"
    
    if [ $? -eq 0 ]; then
        log_message "Successfully restored monitor configuration"
        # Restart waybar to ensure it's positioned correctly
        pkill waybar
        sleep 1
        waybar &
    else
        log_message "Failed to restore monitor configuration"
    fi
}

# Function to check if monitor is connected
is_monitor_connected() {
    hyprctl monitors | grep -q "$MONITOR_NAME"
}

# Function to get current resolution
get_current_resolution() {
    hyprctl monitors | grep -A 10 "$MONITOR_NAME" | grep -E "^[[:space:]]*[0-9]+x[0-9]+" | head -1 | awk '{print $1}'
}

# Main logic
log_message "Monitor hotplug script started"

# Check if we're in a Hyprland session
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    log_message "Not in a Hyprland session, exiting"
    exit 1
fi

# Check if monitor is connected
if is_monitor_connected; then
    current_res=$(get_current_resolution)
    log_message "Monitor $MONITOR_NAME detected with resolution: $current_res"
    
    # Check if the resolution is incorrect (typical low resolution after KVM switch)
    if [[ "$current_res" != "5120x1440" ]]; then
        log_message "Incorrect resolution detected ($current_res), restoring correct configuration"
        restore_monitor_config
    else
        log_message "Monitor already has correct resolution"
    fi
else
    log_message "Monitor $MONITOR_NAME not detected"
fi