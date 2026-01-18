# Vachicorne's VachixOS Configuration

```
< Welcome to Vachicorne's VachixOS! >
 -----------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

Welcome to my personal VachixOS configuration! This repository contains a comprehensive, modular, and production-ready custom NixOS setup optimized for development, gaming, and daily computing.

## 🎯 Overview

This configuration transforms a standard NixOS installation into a powerful, secure, and efficient workstation featuring:

- **Niri** as the Scrollable Tiling Wayland Compositor
- **Noctalia** for the desktop shell and panel
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
├── hosts/                    # Host-specific configurations
│   ├── desktop/             # Desktop machine configuration
│   └── laptop/              # Laptop machine configuration
├── display/                  # Display and graphics configuration
├── fastfetch/                # System information display configuration
├── foot/                     # Foot terminal configuration
├── git/                      # Git configuration and aliases
├── niri/                     # Niri compositor configuration and keybinds
├── noctalia/                 # Noctalia shell configuration
├── hyprpaper/                # Wallpaper management
├── mangowc/                  # MangoWC session
├── neovim/                   # Neovim configuration with LSPs and DAP
├── packages/                 # System and user packages
├── scripts/                  # Utility scripts
├── steam/                    # Gaming and Steam optimizations
└── tmux/                     # Terminal multiplexer setup
```

## ✨ Key Features

### 💻 Niri Desktop Experience
- **Infinite Scrollable Tiling**: Windows are arranged in columns on an infinite horizontal strip.
- **Noctalia Shell**: Provides the top panel, launcher, and system indicators.
- **XWayland Satellite**: For excellent X11 application support.
- **Kvantum Theming**: Tokyo Night theme applied to Qt applications.
- **Animations**: Smooth window opening, closing, and movement.

### 🔒 Security & Privacy
- **Automatic screen locking** (Hyprlock)
- **Kernel hardening** with network and memory protections
- **Sudo password requirements** and privilege escalation controls

### 🎮 Gaming Optimizations
- **10GB persistent NVIDIA shader cache** to eliminate recompilation
- **Proton-GE** compatibility layer
- **MangoHUD** for real-time performance monitoring
- **Gamescope** for optimal gaming performance

### 🛠️ Development Environment
- **NixVim** with comprehensive LSP support
- **Git workflow optimizations** with diff-so-fancy and smart aliases
- **Tmux** with sessionizer for rapid project switching
- **Foot** terminal with fast GPU acceleration

## 🚀 Quick Start

### Desktop Setup
1. **Clone this repository**:
   ```bash
   git clone https://github.com/RodolpheFouquet/nixos-config.git /home/$USER/.config/nixos
   ```

2. **Generate Hardware Config**:
   ```bash
   sudo nixos-generate-config --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix /home/$USER/.config/nixos/hosts/desktop/
   ```

3. **Apply Configuration**:
   ```bash
   sudo nixos-rebuild switch --flake .#desktop
   ```

## ⌨️ Niri Key Shortcuts

### Window & Column Management
| Shortcut | Action |
|----------|--------|
| `Super + H/L` | Focus column Left/Right |
| `Super + J/K` | Focus window Down/Up |
| `Super + Ctrl + H/L` | Move column Left/Right |
| `Super + Ctrl + J/K` | Move window Down/Up |
| `Super + D` | Close window |
| `Super + F` | Fullscreen window |
| `Super + W` | Toggle floating window |
| `Super + Minus/Plus` | Decrease/Increase column width |
| `Super + M` | Maximize column |
| `Super + Tab` | Switch focus between floating/tiling |

### Workspace Navigation
| Shortcut | Action |
|----------|--------|
| `Super + 1-6` | Focus workspace 1-6 |
| `Super + Shift + 1-6` | Move column to workspace 1-6 |
| `Super + Shift + Up/Down` | Focus workspace Up/Down |

### Application Launchers
| Shortcut | Action |
|----------|--------|
| `Super + Return` | Open Terminal (Foot) |
| `Super + G` | Open Browser (Chrome) |
| `Super + R` | Application Launcher (Noctalia) |
| `Super + E` | File Manager (Dolphin) |
| `Super + Shift + L` | Lock Screen |
| `Super + Shift + Slash` | Show Hotkey Overlay |
| `Super + Space` | Open Overview |

### Screenshots
| Shortcut | Action |
|----------|--------|
| `Super + P` | Screenshot selection |
| `Super + Shift + P` | Screenshot full screen |

## 🍎 Mac-Style Shortcuts (via Xremap)

To ease the transition between macOS and Linux, `Super` (Command) keys are remapped to common actions:

| Shortcut | Action |
|----------|--------|
| `Cmd + C` | Copy |
| `Cmd + V` | Paste |
| `Cmd + X` | Cut |
| `Cmd + Z` | Undo |
| `Cmd + S` | Save |
| `Cmd + A` | Select All |
| `Cmd + Left/Right` | Go to Home/End of line |
| `Alt + Left/Right` | Go to Previous/Next Word |
| `Cmd + Backspace` | Delete Line/Word |

## 📟 Tmux & Terminal Workflow

- **Prefix**: `Ctrl + a`
- **Sessionizer**: `Ctrl + a + f` (select project from `~/Code`)
- **Split Horizontal**: `Ctrl + a + "`
- **Split Vertical**: `Ctrl + a + %`

## 🐲 Doom Emacs Configuration
    
The configuration uses **Doom Emacs** via `nix-doom-emacs` for a declarative and reproducible setup. It is configured to replicate the Neovim workflow with strict parity in keybindings and features.
    
### Key Features
- **Evil Mode**: Vim emulation everywhere.
- **LSP & Tree-sitter**: Full support for Nix, Python, Rust, Go, OCaml, Zig, Elixir, Web/JS.
- **Tokyo Night Theme**: Consistent with the rest of the system.
- **Harpoon**: Fast file navigation using the same shortcuts as Neovim.
- **DAP**: Integrated debugger with generic keybindings.
    
### ⌨️ Emacs Key Shortcuts
    
Most shortcuts follow standard Doom Emacs conventions (Space leader), but specific modules have been tuned:
    
#### Harpoon (Navigation)
| Shortcut | Action |
|----------|--------|
| `Space + a` | Add file to Harpoon |
| `Space + e` | Open Harpoon Menu |
| `Space + 1-4` | Go to file 1-4 |
| `Ctrl + h/j/k/l` | Go to file 1/2/3/4 (Fast Switch) |
| `Ctrl + e` | Quick Menu |
    
#### Debugging (DAP)
| Shortcut | Action |
|----------|--------|
| `Space + d + b` | Toggle Breakpoint |
| `Space + d + c` | Continue |
| `Space + d + o` | Step Over |
| `Space + d + i` | Step Into |
| `Space + d + r` | Toggle REPL |
    
#### General
| Shortcut | Action |
|----------|--------|
| `Space + .` | Find File (Project) |
| `Space + /` | Search Project (Rg) |
| `Space + b + [` | Previous Buffer |
| `Space + b + ]` | Next Buffer |
| `Space + w` | Window Management (split, close, move) |
| `g d` | Go to Definition |
| `K` | Hover Documentation |
    
## 🤝 Contributing

Feel free to fork this repository and adapt it for your own use!

## 📜 License

This configuration is provided as-is for educational and personal use.

---

*Built with ❤️ and lots of ☕ by Vachicorne*