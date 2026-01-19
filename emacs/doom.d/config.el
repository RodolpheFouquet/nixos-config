;;; config.el -*- lexical-binding: t; -*-

;; Set theme
(setq doom-theme 'doom-tokyo-night)

;; Set font
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))

;; Set line numbers
(setq display-line-numbers-type 'relative)

;; Set shell to bash (fix for Fish shell warning)
(setq shell-file-name (executable-find "bash"))

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

(after! lsp-mode
  (setq lsp-headerline-breadcrumb-enable nil))

;; Harpoon Keybindings
(map! :leader
      :desc "Harpoon Add File" "a" #'harpoon-add-file
      :desc "Harpoon Menu" "e" #'harpoon-quick-menu-hydra
      :desc "Harpoon File 1" "1" #'harpoon-go-to-1
      :desc "Harpoon File 2" "2" #'harpoon-go-to-2
      :desc "Harpoon File 3" "3" #'harpoon-go-to-3
      :desc "Harpoon File 4" "4" #'harpoon-go-to-4)

(map! :n "C-h" #'harpoon-go-to-1
      :n "C-j" #'harpoon-go-to-2
      :n "C-k" #'harpoon-go-to-3
      :n "C-l" #'harpoon-go-to-4
      :n "C-e" #'harpoon-quick-menu-hydra)

;; DAP Keybindings
(map! :leader
      :prefix ("d" . "debug")
      :desc "Toggle Breakpoint" "b" #'dap-breakpoint-toggle
      :desc "Continue" "c" #'dap-continue
      :desc "Step Over" "o" #'dap-next
      :desc "Step Into" "i" #'dap-step-in
      :desc "Step Out" "u" #'dap-step-out
      :desc "Run Last" "l" #'dap-debug-last
      :desc "Terminate" "t" #'dap-disconnect
      :desc "REPL" "r" #'dap-ui-repl)

;; Keybindings
(map! :leader
      :desc "Toggle treemacs" "t t" #'treemacs)