{ pkgs, ... }:

{
  services.emacs.enable = true;
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-nox;
    extraPackages =
      epkgs: with epkgs; [
        # Essential packages
        use-package

        # Theme
        gruvbox-theme

        # Evil mode (Vim emulation)
        evil
        evil-collection
        evil-commentary
        evil-surround

        # UI enhancements
        doom-modeline
        all-the-icons
        which-key

        # File management and navigation
        helm
        projectile
        helm-projectile
        treemacs
        treemacs-evil
        treemacs-projectile

        # Git integration
        magit
        git-gutter

        # LSP support
        lsp-mode
        lsp-ui
        company
        flycheck

        # Language-specific packages
        nix-mode
        python-mode
        rust-mode
        go-mode
        typescript-mode
        elixir-mode
        zig-mode
        tuareg # OCaml

        # Debugging
        dap-mode
        dape

        # Code formatting
        format-all

        # Org mode enhancements
        org-bullets

        # Terminal emulation
        vterm

        # Additional utilities
        yasnippet
        yasnippet-snippets
        helpful
        exec-path-from-shell
      ];
  };

  # Create Emacs configuration file
  home.file.".emacs.d/init.el".text = ''
    ;;; VachixOS Emacs Configuration
    ;;; Replicating Neovim setup

    ;; Package management
    (require 'package)
    (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                             ("gnu" . "https://elpa.gnu.org/packages/")))
    (package-initialize)

    ;; Use-package for cleaner configuration
    (eval-when-compile
      (require 'use-package))

    ;; Basic settings (matching Neovim opts)
    (setq-default
     display-line-numbers-type 'relative
     tab-width 2
     indent-tabs-mode nil
     c-basic-offset 2)

    (global-display-line-numbers-mode 1)
    (column-number-mode 1)
    (setq select-enable-clipboard t)

    ;; Disable mouse (matching Neovim mouse = "")
    (dolist (k '([mouse-1] [down-mouse-1] [drag-mouse-1] [double-mouse-1] [triple-mouse-1]
                 [mouse-2] [down-mouse-2] [drag-mouse-2] [double-mouse-2] [triple-mouse-2]
                 [mouse-3] [down-mouse-3] [drag-mouse-3] [double-mouse-3] [triple-mouse-3]))
      (global-unset-key k))

    ;; Theme - Gruvbox
    (use-package gruvbox-theme
      :config
      (load-theme 'gruvbox-dark-hard t))

    ;; Evil mode - Vim emulation
    (use-package evil
      :init
      (setq evil-want-integration t)
      (setq evil-want-keybinding nil)
      (setq evil-want-C-u-scroll t)
      (setq evil-want-C-i-jump nil)
      :config
      (evil-mode 1)
      ;; Set leader key to space (matching Neovim)
      (evil-set-leader 'normal (kbd "SPC"))
      (evil-set-leader 'visual (kbd "SPC")))

    (use-package evil-collection
      :after evil
      :config
      (evil-collection-init))

    (use-package evil-commentary
      :after evil
      :config
      (evil-commentary-mode))

    (use-package evil-surround
      :after evil
      :config
      (global-evil-surround-mode 1))

    ;; UI enhancements
    (use-package doom-modeline
      :init (doom-modeline-mode 1)
      :config
      (setq doom-modeline-height 25)
      (setq doom-modeline-bar-width 3))

    (use-package all-the-icons
      :if (display-graphic-p))

    (use-package which-key
      :config
      (which-key-mode)
      (setq which-key-idle-delay 0.3))

    ;; File management - Helm (similar to Telescope)
    (use-package helm
      :bind (("M-x" . helm-M-x)
             ("C-x C-f" . helm-find-files)
             ("C-x b" . helm-buffers-list))
      :config
      (helm-mode 1)
      (setq helm-split-window-inside-p t
            helm-move-to-line-cycle-in-source t))

    (use-package projectile
      :config
      (projectile-mode +1)
      (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

    (use-package helm-projectile
      :after (helm projectile)
      :config
      (helm-projectile-on))

    ;; File tree - Treemacs
    (use-package treemacs
      :defer t
      :config
      (treemacs-resize-icons 16)
      (treemacs-follow-mode t)
      (treemacs-filewatch-mode t))

    (use-package treemacs-evil
      :after (treemacs evil))

    (use-package treemacs-projectile
      :after (treemacs projectile))

    ;; Git integration
    (use-package magit
      :bind ("C-x g" . magit-status))

    (use-package git-gutter
      :config
      (global-git-gutter-mode +1))

    ;; LSP Configuration (matching Neovim LSP setup)
    (use-package lsp-mode
      :init
      (setq lsp-keymap-prefix "C-c l")
      :hook ((nix-mode . lsp)
             (python-mode . lsp)
             (rust-mode . lsp)
             (go-mode . lsp)
             (typescript-mode . lsp)
             (elixir-mode . lsp)
             (zig-mode . lsp)
             (tuareg-mode . lsp)
             (lsp-mode . lsp-enable-which-key-integration))
      :commands lsp
      :config
      ;; LSP keybindings (matching Neovim LSP keymaps)
      (evil-define-key 'normal lsp-mode-map
        "gd" 'lsp-find-definition
        "gD" 'lsp-find-declaration
        "gr" 'lsp-find-references
        "gi" 'lsp-find-implementation
        "K" 'lsp-describe-thing-at-point)
      (evil-define-key 'normal lsp-mode-map
        (kbd "<leader>ca") 'lsp-execute-code-action))

    (use-package lsp-ui
      :hook (lsp-mode . lsp-ui-mode)
      :config
      (setq lsp-ui-sideline-enable t
            lsp-ui-doc-enable t
            lsp-ui-flycheck-enable t))

    (use-package company
      :hook (prog-mode . company-mode)
      :config
      (setq company-minimum-prefix-length 1
            company-idle-delay 0.0))

    (use-package flycheck
      :init (global-flycheck-mode))

    ;; Language modes
    (use-package nix-mode
      :mode "\\.nix\\'")

    (use-package python-mode
      :mode "\\.py\\'")

    (use-package rust-mode
      :mode "\\.rs\\'")

    (use-package go-mode
      :mode "\\.go\\'")

    (use-package typescript-mode
      :mode "\\.ts\\'\\|\\.tsx\\'")

    (use-package elixir-mode
      :mode "\\.ex\\'\\|\\.exs\\'")

    (use-package zig-mode
      :mode "\\.zig\\'")

    (use-package tuareg
      :mode "\\.ml\\'\\|\\.mli\\'")

    ;; Code formatting (matching Neovim conform-nvim)
    (use-package format-all
      :hook (prog-mode . format-all-mode)
      :config
      (setq format-all-formatters
            '(("Nix" nixfmt)
              ("Python" ruff)
              ("Rust" rustfmt)
              ("OCaml" ocamlformat)
              ("Go" gofmt)
              ("TypeScript" prettier)
              ("JavaScript" prettier)
              ("Zig" zig))))

    ;; Debug Adapter Protocol (matching Neovim DAP)
    (use-package dap-mode
      :config
      (dap-auto-configure-mode)
      ;; Try to require DAP language support (may not be available)
      (ignore-errors (require 'dap-python))
      (ignore-errors (require 'dap-gdb-lldb))
      ;; DAP keybindings (matching Neovim DAP keymaps)
      (evil-define-key 'normal dap-mode-map
        (kbd "<leader>db") 'dap-breakpoint-toggle
        (kbd "<leader>dB") 'dap-breakpoint-condition
        (kbd "<leader>dc") 'dap-continue
        (kbd "<leader>do") 'dap-next
        (kbd "<leader>di") 'dap-step-in
        (kbd "<leader>du") 'dap-step-out
        (kbd "<leader>dr") 'dap-switch-to-repl
        (kbd "<leader>dl") 'dap-debug-last
        (kbd "<leader>dt") 'dap-disconnect)
      ;; Enable DAP UI
      (dap-ui-mode 1)
      (evil-define-key 'normal dap-mode-map
        (kbd "<leader>dui") 'dap-ui-many-windows-toggle))

    ;; Alternative modern debugger (dape)
    (use-package dape
      :config
      ;; Dape keybindings as alternative to DAP
      (evil-define-key 'normal 'global
        (kbd "<leader>Da") 'dape
        (kbd "<leader>Db") 'dape-breakpoint-toggle
        (kbd "<leader>Dc") 'dape-continue
        (kbd "<leader>Dn") 'dape-next
        (kbd "<leader>Ds") 'dape-step-in
        (kbd "<leader>Do") 'dape-step-out))

    ;; Terminal emulation
    (use-package vterm
      :bind ("C-c t" . vterm))

    ;; Snippets
    (use-package yasnippet
      :config
      (yas-global-mode 1))

    (use-package yasnippet-snippets
      :after yasnippet)

    ;; Helpful
    (use-package helpful
      :bind (("C-h f" . helpful-callable)
             ("C-h v" . helpful-variable)
             ("C-h k" . helpful-key)))

    ;; Exec path from shell
    (use-package exec-path-from-shell
      :if (memq window-system '(mac ns x))
      :config
      (exec-path-from-shell-initialize))

    ;; Key bindings (matching Neovim keymaps)
    (evil-define-key 'normal 'global
      ;; File finding (matching Telescope keymaps)
      (kbd "<leader>ff") 'helm-find-files
      (kbd "<leader>fg") 'helm-do-grep-ag
      
      ;; Buffer/project navigation
      (kbd "<leader>b") 'helm-buffers-list
      (kbd "<leader>p") 'helm-projectile
      
      ;; Treemacs toggle
      (kbd "<leader>e") 'treemacs)

    ;; Additional settings
    (setq inhibit-startup-message t)
    (tool-bar-mode -1)
    (menu-bar-mode -1)
    (scroll-bar-mode -1)
    (setq ring-bell-function 'ignore)

    ;; Backup files
    (setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
    (setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

    ;; Custom settings end here
    (custom-set-variables
     ;; custom-set-variables was added by Custom.
     ;; If you edit it by hand, you could mess it up, so be careful.
     ;; Your init file should contain only one such instance.
     ;; If there is more than one, they won't work right.
     )
    (custom-set-faces
     ;; custom-set-faces was added by Custom.
     ;; If you edit it by hand, you could mess it up, so be careful.
     ;; Your init file should contain only one such instance.
     ;; If there is more than one, they won't work right.
     )
  '';
}

