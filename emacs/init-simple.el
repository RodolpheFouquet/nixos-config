;;; init-simple.el --- Doom-inspired Emacs configuration -*- lexical-binding: t; -*-

;;; Code:

;; Package management is handled by Nix, so we don't need package.el
(setq package-enable-at-startup nil)

;; Basic settings
(setq inhibit-startup-message t
      inhibit-splash-screen t
      initial-scratch-message nil
      load-prefer-newer t
      backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
      auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory "auto-save-list/") t)))

;; UI Configuration
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Font
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 140)

;; Theme
(load-theme 'doom-gruvbox t)
(require 'doom-modeline)
(doom-modeline-mode 1)

;; Evil mode
(setq evil-want-keybinding nil
      evil-want-C-u-scroll t
      evil-want-fine-undo t)
(require 'evil)
(evil-mode 1)
(require 'evil-collection)
(evil-collection-init)

;; Which-key
(require 'which-key)
(which-key-mode 1)
(setq which-key-idle-delay 0.3)

;; Company
(require 'company)
(global-company-mode 1)
(setq company-idle-delay 0.2
      company-minimum-prefix-length 2)

;; Vertico and friends
(require 'vertico)
(vertico-mode 1)
(require 'marginalia)
(marginalia-mode 1)
(require 'orderless)
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion))))

;; LSP
(require 'lsp-mode)
(setq lsp-ui-doc-enable nil
      lsp-ui-doc-show-with-cursor nil
      lsp-ui-doc-show-with-mouse nil
      lsp-signature-auto-activate nil
      lsp-eldoc-render-all nil
      lsp-ui-sideline-enable nil
      lsp-keymap-prefix "C-c l")

;; Language modes
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.ml\\'" . tuareg-mode))
(add-to-list 'auto-mode-alist '("\\.ex\\'" . elixir-mode))
(add-to-list 'auto-mode-alist '("\\.zig\\'" . zig-mode))

;; LSP hooks
(add-hook 'nix-mode-hook #'lsp)
(add-hook 'python-mode-hook #'lsp)
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'go-mode-hook #'lsp)
(add-hook 'typescript-mode-hook #'lsp)
(add-hook 'tuareg-mode-hook #'lsp)
(add-hook 'elixir-mode-hook #'lsp)
(add-hook 'zig-mode-hook #'lsp)
(add-hook 'c-mode-hook #'lsp)
(add-hook 'c++-mode-hook #'lsp)

;; Projectile
(require 'projectile)
(projectile-mode 1)
(setq projectile-project-search-path '("~/Code" "~/.config"))

;; Magit
(require 'magit)

;; Treemacs
(require 'treemacs)
(require 'treemacs-evil)
(require 'treemacs-projectile)
(setq treemacs-width 30)

;; Org mode
(require 'org)
(setq org-directory "~/org/")
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; Terminal
(require 'vterm)

;; Keybindings using general
(require 'general)
(general-create-definer leader-def
  :keymaps 'override
  :states '(normal visual)
  :prefix "SPC")

(leader-def
  "f f" 'find-file
  "f r" 'recentf-open-files
  "b b" 'switch-to-buffer
  "b k" 'kill-buffer
  "w w" 'other-window
  "w d" 'delete-window
  "w s" 'split-window-below
  "w v" 'split-window-right
  "p p" 'projectile-switch-project
  "p f" 'projectile-find-file
  "p s" 'projectile-grep
  "g s" 'magit-status
  "t t" 'treemacs
  "SPC" 'execute-extended-command
  ":" 'eval-expression)

;; Additional settings
(setq-default indent-tabs-mode nil
              tab-width 2
              standard-indent 2)
(setq js-indent-level 2
      typescript-indent-level 2
      json-indent-level 2
      c-basic-offset 2
      nix-indent-level 2
      python-indent-offset 2
      sh-basic-offset 2
      sh-indentation 2)
(electric-pair-mode 1)
(show-paren-mode 1)
(global-auto-revert-mode 1)

;; Rainbow delimiters
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; Smartparens
(require 'smartparens-config)
(smartparens-global-mode 1)

;; Dashboard
(require 'dashboard)
(dashboard-setup-startup-hook)
(setq dashboard-startup-banner 'logo
      dashboard-center-content t
      dashboard-items '((recents  . 5)
                        (projects . 5)))

;;; init-simple.el ends here