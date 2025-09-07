#!/usr/bin/env bash

# VM Memory Manager - Automatic memory ballooning
# Monitors host memory usage and adjusts VM memory allocation

set -euo pipefail

# Configuration
LOG_FILE="/var/log/vm-memory-manager.log"
MEMORY_HIGH_THRESHOLD=80  # Balloon down VMs when host memory > 80%
MEMORY_LOW_THRESHOLD=60   # Balloon up VMs when host memory < 60%
VM_MIN_MEMORY=2048        # Minimum VM memory in MB
VM_MAX_MEMORY=8192        # Maximum VM memory in MB
CHECK_INTERVAL=60         # Check interval in seconds
VIRSH_CONNECT="qemu:///system"

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [VM-MEM-MGR] $*" | tee -a "$LOG_FILE"
}

# Get host memory usage percentage
get_host_memory_usage() {
    local mem_info
    mem_info=$(cat /proc/meminfo)
    
    local total_kb available_kb used_kb
    total_kb=$(echo "$mem_info" | grep '^MemTotal:' | awk '{print $2}')
    available_kb=$(echo "$mem_info" | grep '^MemAvailable:' | awk '{print $2}')
    
    used_kb=$((total_kb - available_kb))
    echo $((used_kb * 100 / total_kb))
}

# Check if guest agent is responsive
check_guest_agent() {
    local vm_name="$1"
    if virsh --connect "$VIRSH_CONNECT" qemu-agent-command "$vm_name" '{"execute":"guest-ping"}' >/dev/null 2>&1; then
        log "$vm_name: Guest agent responsive"
        return 0
    else
        log "$vm_name: Guest agent not responding"
        return 1
    fi
}

# Get VM current memory in MB (using RSS for actual usage)
get_vm_memory() {
    local vm_name="$1"
    local memory_kb
    
    # Use RSS (actual host memory consumption)
    memory_kb=$(virsh --connect "$VIRSH_CONNECT" domstats "$vm_name" | grep 'balloon.rss=' | cut -d= -f2)
    echo $((memory_kb / 1024))
}

# Get VM maximum memory in MB
get_vm_max_memory() {
    local vm_name="$1"
    local memory_kb
    memory_kb=$(virsh --connect "$VIRSH_CONNECT" domstats "$vm_name" | grep 'balloon.maximum=' | cut -d= -f2)
    echo $((memory_kb / 1024))
}

# Set VM memory balloon
set_vm_memory() {
    local vm_name="$1"
    local target_mb="$2"
    
    log "Setting $vm_name memory to ${target_mb}MB"
    if virsh --connect "$VIRSH_CONNECT" qemu-monitor-command --hmp "$vm_name" "balloon $target_mb" >/dev/null 2>&1; then
        log "Successfully set $vm_name memory to ${target_mb}MB"
        return 0
    else
        log "ERROR: Failed to set $vm_name memory to ${target_mb}MB"
        return 1
    fi
}

# Get list of running VMs
get_running_vms() {
    virsh --connect "$VIRSH_CONNECT" list --state-running --name | grep -v '^$'
}

# Calculate target memory for VMs based on host usage
calculate_target_memory() {
    local host_usage="$1"
    local current_memory="$2"
    local max_memory="$3"
    
    if [ "$host_usage" -gt "$MEMORY_HIGH_THRESHOLD" ]; then
        # Host memory pressure - reduce VM memory
        local reduction=$((current_memory * 20 / 100))  # Reduce by 20%
        local target=$((current_memory - reduction))
        
        # Ensure minimum
        if [ "$target" -lt "$VM_MIN_MEMORY" ]; then
            target="$VM_MIN_MEMORY"
        fi
        
        echo "$target"
    elif [ "$host_usage" -lt "$MEMORY_LOW_THRESHOLD" ]; then
        # Host has available memory - can increase VM memory
        local increase=$((current_memory * 10 / 100))  # Increase by 10%
        local target=$((current_memory + increase))
        
        # Ensure maximum limits
        if [ "$target" -gt "$max_memory" ]; then
            target="$max_memory"
        fi
        if [ "$target" -gt "$VM_MAX_MEMORY" ]; then
            target="$VM_MAX_MEMORY"
        fi
        
        echo "$target"
    else
        # No change needed
        echo "$current_memory"
    fi
}

# Main memory management function
manage_vm_memory() {
    local host_usage
    host_usage=$(get_host_memory_usage)
    
    log "Host memory usage: ${host_usage}%"
    
    # Get running VMs
    local running_vms
    if ! running_vms=$(get_running_vms); then
        log "ERROR: Failed to get running VMs"
        return 1
    fi
    
    if [ -z "$running_vms" ]; then
        log "No running VMs found"
        return 0
    fi
    
    # Process each VM
    while IFS= read -r vm_name; do
        [ -z "$vm_name" ] && continue
        
        log "Processing VM: $vm_name"
        
        # Check guest agent responsiveness
        check_guest_agent "$vm_name"
        
        local current_memory max_memory target_memory
        
        if ! current_memory=$(get_vm_memory "$vm_name"); then
            log "ERROR: Failed to get current memory for $vm_name"
            continue
        fi
        
        if ! max_memory=$(get_vm_max_memory "$vm_name"); then
            log "ERROR: Failed to get max memory for $vm_name"
            continue
        fi
        
        target_memory=$(calculate_target_memory "$host_usage" "$current_memory" "$max_memory")
        
        log "$vm_name: current=${current_memory}MB, max=${max_memory}MB, target=${target_memory}MB"
        
        # Only adjust if there's a significant difference (>100MB)
        local diff=$((target_memory - current_memory))
        if [ "${diff#-}" -gt 100 ]; then
            set_vm_memory "$vm_name" "$target_memory"
        else
            log "$vm_name: No adjustment needed (diff: ${diff}MB)"
        fi
        
    done <<< "$running_vms"
}

# Initialize log
log "VM Memory Manager starting..."

# Main loop
while true; do
    if ! manage_vm_memory; then
        log "ERROR: Memory management cycle failed"
    fi
    
    log "Sleeping for ${CHECK_INTERVAL} seconds..."
    sleep "$CHECK_INTERVAL"
done