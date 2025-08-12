;;; config.el -*- lexical-binding: t; -*-

;; Set theme
(setq doom-theme 'doom-gruvbox)

;; Set font
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))

;; Set line numbers
(setq display-line-numbers-type 'relative)

;; Disable mouse
(when (display-graphic-p)
  (context-menu-mode -1)
  (tooltip-mode -1))

;; Configure Evil
(setq evil-want-fine-undo t)
(setq evil-want-C-u-scroll t)

;; Configure org-mode
(setq org-directory "~/org/")

;; Configure projectile
(setq projectile-project-search-path '("~/Code" "~/.config"))

;; Configure treemacs
(setq treemacs-width 30)

;; Configure which-key
(setq which-key-idle-delay 0.3)

;; Configure company
(setq company-idle-delay 0.2)
(setq company-minimum-prefix-length 2)

;; Configure LSP
(setq lsp-ui-doc-enable nil)
(setq lsp-ui-doc-show-with-cursor nil)
(setq lsp-ui-doc-show-with-mouse nil)
(setq lsp-signature-auto-activate nil)
(setq lsp-eldoc-render-all nil)
(setq lsp-ui-sideline-enable nil)

;; Keybindings
(map! :leader
      :desc "Toggle treemacs" "t t" #'treemacs)