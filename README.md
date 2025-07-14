# Vachicorne's NixOS Configuration

```
      \   ^__^
       \  (oo)\_______
          (__)\       )\/\
              ||----w |
              ||     ||
```

Welcome to my personal NixOS configuration! This repository contains a comprehensive, modular, and production-ready NixOS setup optimized for development, gaming, and daily computing.

## 🎯 Overview

This configuration transforms a standard NixOS installation into a powerful, secure, and efficient workstation featuring:

- **Hyprland** as the Wayland compositor with custom animations and keybinds
- **NVIDIA gaming optimizations** with persistent shader caching
- **Security hardening** with automatic screen locking and system protections
- **Development environment** with Neovim, debugging tools, and git workflow optimizations
- **Performance tuning** for both productivity and gaming workloads

## 🏗️ Architecture

The configuration follows a modular architecture where each component is separated into its own directory:

```
.
├── configuration.nix          # Main system configuration
├── home.nix                  # Home Manager entry point
├── flake.nix                 # Flake configuration with inputs
├── hardware-configuration.nix # Hardware-specific settings
├── display/                  # Display and graphics configuration
├── git/                      # Git configuration and aliases
├── hyprland/                 # Hyprland window manager setup
│   ├── animations.nix        # Custom animations and transitions
│   ├── binds.nix            # Keybindings and shortcuts
│   ├── hypridle.nix         # Idle management and timeouts
│   ├── hyprlock.nix         # Screen locking configuration
│   └── pyprland.nix         # Pyprland extensions (scratchpads)
├── hyprpaper/               # Wallpaper management
├── neovim/                  # Neovim configuration with LSPs and DAP
├── packages/                # System and user packages
├── steam/                   # Gaming and Steam optimizations
├── tmux/                    # Terminal multiplexer setup
└── waybar/                  # Status bar configuration
```

## ✨ Key Features

### 🔒 Security & Privacy
- **Automatic screen locking** after 10 minutes of inactivity
- **Progressive idle management** (dim → lock → display off → suspend)
- **Kernel hardening** with network and memory protections
- **Sudo password requirements** and privilege escalation controls

### 🎮 Gaming Optimizations
- **10GB persistent NVIDIA shader cache** to eliminate recompilation
- **Proton-GE** compatibility layer for enhanced game support
- **MangoHUD** for real-time performance monitoring
- **Gamescope** with RT priority for optimal gaming performance
- **NVIDIA beta drivers** for latest gaming features

### 💻 Development Environment
- **NixVim** with comprehensive LSP support for multiple languages
- **Debug Adapter Protocol (DAP)** for interactive debugging
- **Git workflow optimizations** with diff-so-fancy and smart aliases
- **Terminal tools** including tmux with sessionizer, fish shell with starship prompt, yazi file manager, and zoxide smart navigation

### 🖥️ Desktop Experience
- **Hyprland** with custom Vi-style keybindings (HJKL navigation)
- **Waybar** with system monitoring including CPU temperature
- **Gruvbox theming** throughout the desktop environment
- **Custom animations** and smooth transitions

### ⚡ Performance Tuning
- **CPU performance governor** for maximum responsiveness
- **IRQ balancing** across cores for better multithreading
- **Automatic nix store optimization** with weekly garbage collection

## 🚀 Quick Start

1. **Clone this repository**:
   ```bash
   git clone https://github.com/RodolpheFouquet/nixos-config.git /home/$USER/.config/nixos
   ```

2. **Update hardware configuration**:
   ```bash
   sudo nixos-generate-config --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix /home/$USER/.config/nixos/
   ```

3. **Customize for your system**:
   - Update monitor configuration in `hyprland/default.nix`
   - Adjust thermal zone in `waybar/default.nix` for temperature monitoring
   - Modify user details in `git/default.nix`

4. **Apply the configuration**:
   ```bash
   sudo nixos-rebuild switch --flake /home/$USER/.config/nixos
   ```

## 🎮 Gaming Setup

This configuration includes optimizations specifically for NVIDIA gaming:

- **Persistent shader cache**: Games won't need to recompile shaders on subsequent launches
- **Enhanced Proton compatibility**: NVAPI support for better Windows game compatibility  
- **Performance monitoring**: MangoHUD overlay for FPS and system stats
- **Game streaming**: Firewall configured for Steam Remote Play and local streaming

Launch games with MangoHUD: `mangohud %command%` in Steam launch options.

## ⌨️ Hyprland Key Shortcuts

### Window Management
| Shortcut | Action |
|----------|--------|
| `SUPER + H/J/K/L` | Move focus (Vi-style navigation) |
| `SUPER + SHIFT + H/J/K/L` | Move active window |
| `SUPER + V` | Toggle floating mode |
| `SUPER + C` | Close active window |

### Workspace Management
| Shortcut | Action |
|----------|--------|
| `SUPER + 1-9` | Switch to workspace 1-9 |
| `SUPER + SHIFT + 1-9` | Move window to workspace 1-9 |
| `SUPER + S` | Toggle special workspace |
| `SUPER + SHIFT + S` | Move window to special workspace |

### Application Launchers
| Shortcut | Action |
|----------|--------|
| `SUPER + Q` | Open terminal (Ghostty) |
| `SUPER + F` | Open browser (Chrome) |
| `SUPER + R` | Application launcher (Wofi) |

### System Controls
| Shortcut | Action |
|----------|--------|
| `SUPER + SHIFT + L` | Lock screen |
| `XF86AudioRaiseVolume` | Increase volume 5% |
| `XF86AudioLowerVolume` | Decrease volume 5% |
| `XF86AudioMute` | Toggle mute |
| `Print` | Screenshot selection (copy to clipboard) |
| `SUPER + Print` | Screenshot full screen (copy to clipboard) |

### Scratchpad Terminals
| Shortcut | Action |
|----------|--------|
| `SUPER + T` | Toggle terminal scratchpad |
| `SUPER + E` | Toggle file manager scratchpad (yazi) |
| `SUPER + M` | Toggle music player scratchpad (ncmpcpp) |
| `SUPER + Z` | Toggle zoom/magnify |

### Mouse Controls
| Action | Binding |
|--------|---------|
| `SUPER + Left Click` | Move window |
| `SUPER + Right Click` | Resize window |

## 🛠️ Git Workflow

Enhanced git experience with:
- `gap` - Interactive patch staging without pressing Enter repeatedly
- `gl` - Pretty git log with graph and colors
- `gs` - Git status
- Pull with rebase enabled by default
- Rerere for automatic conflict resolution

## 📟 Tmux & Terminal Workflow

### Tmux Configuration
- **Prefix key**: `Ctrl-a` (instead of default `Ctrl-b`)
- **Mouse support**: Enabled for pane selection and resizing
- **Session persistence**: Automatic restore with resurrect and continuum plugins
- **Base index**: Windows and panes start from 1
- **Theme**: Gruvbox color scheme

### Sessionizer Function
Quickly create and switch to tmux sessions for your projects:

```fish
sessionizer [directory]
```

- **Without arguments**: Opens fzf to select from ~/Code and ~/.config directories
- **With directory**: Creates/switches to session for specific directory
- **Features**:
  - Searches projects up to 2 levels deep in ~/Code
  - Automatically adds visited directories to zoxide database
  - Smart session naming (handles dots, dashes, slashes)
  - Works both inside and outside tmux

### Zoxide Integration
Smart directory jumping with learning:
- `z <partial-name>` - Jump to frequently visited directories
- `zi` - Interactive directory selection with fzf
- Automatically learns from sessionizer usage

### Key Tmux Shortcuts
| Shortcut | Action |
|----------|--------|
| `Ctrl-a c` | Create new window |
| `Ctrl-a ,` | Rename current window |
| `Ctrl-a %` | Split pane horizontally |
| `Ctrl-a "` | Split pane vertically |
| `Ctrl-a h/j/k/l` | Navigate panes (if configured) |
| `Ctrl-a d` | Detach from session |
| `Ctrl-a s` | List and switch sessions |
| `Ctrl-a f` | Open sessionizer in new window |

## 📦 Included Software

### Development
- **Neovim** with LSPs for Nix, Python, Rust, Go, TypeScript, Elixir, Zig, OCaml
- **Debug adapters** for multiple languages
- **Git tools** with diff-so-fancy
- **Terminal utilities**: yazi, fd, eza, fzf, ripgrep, zoxide

### Gaming & Graphics
- **Steam** with Proton-GE
- **MangoHUD** performance overlay
- **Gamescope** compositor
- **NVIDIA drivers** (beta branch)

### System Monitoring
- **htop, btop, iotop** for system monitoring
- **powertop** for power management
- **Waybar** with CPU temperature display

## 🔧 Customization

This configuration is designed to be easily customizable:

1. **Add new packages**: Edit `packages/default.nix`
2. **Modify keybindings**: Update `hyprland/binds.nix`  
3. **Adjust animations**: Customize `hyprland/animations.nix`
4. **Change themes**: Modify Waybar CSS in `waybar/default.nix`
5. **Add git aliases**: Update `git/default.nix`

## 📝 System Information

- **OS**: NixOS 25.05
- **Window Manager**: Hyprland (Wayland)
- **Status Bar**: Waybar
- **Terminal**: Ghostty
- **Shell**: Fish with Starship prompt
- **Editor**: Neovim (NixVim)
- **Theme**: Gruvbox

## 🤝 Contributing

Feel free to fork this repository and adapt it for your own use! If you find improvements or fixes, pull requests are welcome.

## 📜 License

This configuration is provided as-is for educational and personal use. Feel free to use, modify, and distribute according to your needs.

---

*Built with ❤️ and lots of ☕ by Vachicorne*