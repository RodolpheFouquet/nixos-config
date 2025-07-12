# NixOS Configuration Improvements

This branch contains security, performance, and functionality improvements to the NixOS configuration.

## 🔒 Security Enhancements

### Screen Locking & Idle Management
- **Added `hypridle.nix`**: Implements automatic screen timeout, locking, and system suspend
  - Screen dims after 5 minutes
  - Auto-lock after 10 minutes  
  - Display off after 15 minutes
  - System suspend after 30 minutes

- **Added `hyprlock.nix`**: Secure lock screen with blurred background
  - Password authentication required
  - Clean, modern interface with time display
  - Prevents unauthorized access when away

### System Hardening
- **Kernel security parameters**: Network protection, memory hardening, ptrace restrictions
- **Sudo security**: Requires password for wheel group users
- **Polkit**: Proper privilege escalation management

## ⚡ Performance Optimizations

### System Performance
- **CPU governor**: Set to "performance" for maximum responsiveness
- **IRQ balancing**: Enabled for better interrupt handling
- **tmpfs boot**: Faster boot times with temporary filesystem
- **Boot cleanup**: Automatic cleanup on boot

### Nix Store Optimization
- **Auto-optimization**: Automatic store optimization to save disk space
- **Garbage collection**: Weekly cleanup of old generations (30+ days)
- **Efficient builds**: Reduced rebuild times and disk usage

## 🛠️ Enhanced Functionality

### System Monitoring
- **Waybar temperature**: Added CPU temperature monitoring
- **Additional tools**: htop, btop, iotop, powertop for system monitoring

### Development Tools
- **File management**: ranger, fd, eza for better file operations
- **Network tools**: nmap, tcpdump, wireshark for network analysis
- **Security tools**: pass, gnupg for credential management
- **Utilities**: jq, yq, tree, zip/unzip for daily tasks

### Hyprland Enhancements
- **Pyprland integration**: Scratchpad terminals and enhanced workspace management
- **Better organization**: Modular configuration with proper imports

## 🎯 Configuration Organization

### Modular Structure
- Each component properly separated into its own module
- Clean imports and dependencies
- Easy to maintain and extend

### Future-Ready
- Configuration prepared for multi-machine setups
- Separation of desktop vs laptop specific settings
- Scalable architecture for additional features

## 🚀 Usage

After applying these changes:

1. **Rebuild system**: `sudo nixos-rebuild switch`
2. **Lock screen**: `hyprlock` or automatic after 10 minutes
3. **Monitor system**: Use new tools like `btop`, `powertop`
4. **Manage files**: `ranger` for file management, `eza` instead of `ls`

## 📝 Notes

- Temperature monitoring may need adjustment of `thermal-zone` and `hwmon-path` based on your hardware
- Screen locking provides immediate security improvement
- Performance tweaks are optimized for desktop usage
- All changes maintain existing functionality while adding new features

## 🔄 Rollback

If any issues occur, rollback with:
```bash
sudo nixos-rebuild switch --rollback
```

The modular design ensures individual components can be disabled by commenting out imports if needed.