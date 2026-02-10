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
│   ├── laptop/              # Laptop machine configuration
│   └── t440p/               # Lenovo T440p configuration
├── display/                  # Display and graphics configuration
├── fastfetch/                # System information display configuration
├── ghostty/                  # Ghostty terminal configuration
├── git/                      # Git configuration and aliases
├── noctalia/                 # Noctalia shell configuration
├── hyprpaper/                # Wallpaper management
├── neovim/                   # Neovim configuration with LSPs and DAP
├── packages/                 # System and user packages
├── scripts/                  # Utility scripts
├── steam/                    # Gaming and Steam optimizations
├── tmux/                     # Terminal multiplexer setup
├── xmonad/                   # XMonad window manager configuration
└── walker/                   # Walker application launcher
```

## ✨ Key Features

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
- **Ghostty** terminal with fast GPU acceleration

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

### Laptop Setup
1. **Clone this repository**:
   ```bash
   git clone https://github.com/RodolpheFouquet/nixos-config.git /home/$USER/.config/nixos
   ```

2. **Generate Hardware Config**:
   ```bash
   sudo nixos-generate-config --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix /home/$USER/.config/nixos/hosts/laptop/
   ```

3. **Apply Configuration**:
   ```bash
   sudo nixos-rebuild switch --flake .#laptop
   ```

### Lenovo T440p Installation Guide
1. **Boot from NixOS ISO**.
2. **Partition the disk** (assuming UEFI):
   ```bash
   # Create GPT partition table
   parted /dev/sda -- mklabel gpt
   # ESP partition (512MB)
   parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
   parted /dev/sda -- set 1 esp on
   # Root partition (remainder)
   parted /dev/sda -- mkpart primary ext4 512MiB 100%
   ```
3. **Format partitions**:
   ```bash
   mkfs.vfat -F 32 -n boot /dev/sda1
   mkfs.ext4 -L nixos /dev/sda2
   ```
4. **Mount partitions**:
   ```bash
   mount /dev/disk/by-label/nixos /mnt
   mkdir -p /mnt/boot
   mount /dev/disk/by-label/boot /mnt/boot
   ```
5. **Clone this repository**:
   ```bash
   git clone https://github.com/RodolpheFouquet/nixos-config.git /mnt/etc/nixos
   ```
6. **Generate Hardware Config**:
   ```bash
   nixos-generate-config --root /mnt --show-hardware-config > /mnt/etc/nixos/hosts/t440p/hardware-configuration.nix
   ```
7. **Install NixOS**:
   ```bash
   nixos-install --flake /mnt/etc/nixos#t440p
   ```
8. **Reboot and enjoy!**

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

## 🐹 Go Configuration

A comprehensive Go development environment is set up for both Neovim and Emacs, ensuring a consistent experience across editors.

### Features
- **LSP**: `gopls` provides robust auto-completion, navigation (`gd`), and refactoring.
- **Formatting**: `goimports` runs on save to format code and manage imports automatically.
- **Debugging**: Full **DAP** (Debug Adapter Protocol) support via `delve` and `dap-go`/`dap-mode`.
- **Testing**: Integrated `gotests` for generating table-driven tests.
- **Linting**: `golangci-lint` available for static analysis.
- **Tools**: `gomodifytags` (struct tags), `impl` (interface stubs), `gore` (REPL).

### Debugging (DAP)
Both editors share similar mnemonic keybindings for debugging Go applications:

| Action | Neovim (`<leader>d...`) | Emacs (`SPC d...`) |
|--------|-------------------------|--------------------|
| **Toggle Breakpoint** | `b` | `b` |
| **Continue** | `c` | `c` |
| **Step Over** | `o` | `o` |
| **Step Into** | `i` | `i` |
| **Step Out** | `u` | `u` |
| **REPL** | `r` | `r` |
| **Terminate** | `t` | `t` |

## 🤝 Contributing

Feel free to fork this repository and adapt it for your own use!

## 📜 License

This configuration is provided as-is for educational and personal use.

---

*Built with ❤️ and lots of ☕ by Vachicorne*