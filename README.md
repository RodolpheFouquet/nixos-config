# Vachicorne's NixOS/nix-darwin Configuration

```
< Welcome to Vachicorne's Configuration! >
 -----------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

Welcome to my personal NixOS/nix-darwin configuration! This repository contains a comprehensive, modular, and production-ready setup for multiple hosts.

## Overview

This configuration manages:
- **NixOS** on desktop, laptop (laptopnul), and T440p hosts
- **nix-darwin** on Mac Mini (mac-mini)
- **Home Manager** for user environment management

## Architecture

```
.
├── configuration.nix              # Main system configuration (imports modules/)
├── home.nix                      # Home Manager entry point (Linux)
├── home-darwin.nix               # Home Manager entry point (macOS)
├── flake.nix                     # Flake configuration with inputs
├── lib/
│   └── dendritic.nix             # Recursive module loader
├── modules/                      # Modular configuration
│   ├── core/                     # Core system modules
│   │   ├── boot.nix              # Kernel, modules, sysctl
│   │   ├── constants.nix         # Shared constants (paths, host types)
│   │   ├── localization.nix      # Time, locale settings
│   │   ├── networking.nix        # Network, firewall, SSH
│   │   ├── nix.nix              # Nix settings, overlays, auto-upgrade
│   │   ├── packages.nix         # System packages
│   │   ├── security.nix         # Sudo, polkit
│   │   ├── user.nix            # User accounts, environment
│   │   └── variables.nix        # Username, home directory
│   ├── desktop/
│   │   └── plasma.nix           # KDE Plasma, pipewire, SDDM
│   └── services/
│       ├── backup.nix           # Restic backup configuration
│       ├── filesystems.nix      # Mount points (SMB)
│       ├── general.nix          # Bluetooth, printing, etc.
│       └── printing.nix         # CUPS, SANE
├── hosts/                        # Host-specific configurations
│   ├── desktop/                 # Desktop machine (NixOS)
│   ├── laptop/                  # Laptop machine (NixOS)
│   ├── mac-mini/                # Mac Mini (nix-darwin)
│   └── t440p/                   # Lenovo T440p (NixOS)
├── neovim/                       # NixVim configuration
├── tmux/                        # Terminal multiplexer setup
├── git/                         # Git configuration
├── packages/                     # Shared user packages
│   └── shared.nix              # Packages for all hosts
└── ...
```

## Hosts

| Host | Type | Description |
|------|------|-------------|
| `desktop` | NixOS | Main desktop workstation |
| `laptopnul` | NixOS | Laptop configuration |
| `t440p` | NixOS | Lenovo T440p legacy machine |
| `mac-mini` | nix-darwin | Apple Mac Mini (macOS) |

## Quick Start

### NixOS

```bash
# Clone repository
git clone https://github.com/vachicorne/nixos-config.git ~/.config/nixos

# Apply configuration
sudo nixos-rebuild switch --flake ~/.config/nixos#desktop
```

### nix-darwin (macOS)

```bash
# Clone repository
git clone https://github.com/vachicorne/nixos-config.git ~/.config/nixos

# Apply configuration
sudo darwin-rebuild switch --flake ~/.config/nixos#mac-mini
```

## Key Features

### Development Environment
- **NixVim** with LSP support for Nix, Python, Rust, Go, OCaml, Zig, Elixir
- **Git** with diff-so-fancy and smart aliases
- **Tmux** with sessionizer for rapid project switching
- **Direnv** for per-directory environment variables

### Gaming (NixOS)
- **NVIDIA optimizations** with persistent shader caching
- **MangoHUD** for real-time performance monitoring
- **Gamescope** for nested gaming
- **Proton-GE** compatibility layer

### Security
- **Kernel hardening** with network and memory protections
- **Automatic screen locking**
- **Sudo password requirements**

## Module System

The configuration uses a custom `dendritic.nix` loader that recursively loads modules from the `modules/` directory. Each module can conditionally apply based on `systemType` (`"nixos"` or `"darwin"`).

Example module structure:
```nix
{ lib, config, pkgs, systemType ? null, ... }:

lib.optionalAttrs (systemType == "nixos") {
  # NixOS-only configuration
}
```

---

*Built with ❤️ and ☕ by Vachicorne*
