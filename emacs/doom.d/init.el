;;; init.el -*- lexical-binding: t; -*-

(doom! :input

       :completion
       company           ; the ultimate code completion backend
       vertico           ; the search engine of the future

       :ui
       doom              ; what makes DOOM look the way it does
       doom-dashboard    ; a nifty splash screen for Emacs
       modeline          ; snazzy, Atom-inspired modeline, plus API
       nav-flash         ; blink cursor line after big motions
       ophints           ; highlight the region an operation acts on
       (popup +defaults)   ; tame sudden yet inevitable temporary windows
       treemacs          ; a project drawer, like neotree but cooler
       vc-gutter         ; vcs diff in the fringe
       vi-tilde-fringe   ; fringe tildes to mark beyond EOB
       workspaces        ; tab emulation, persistence & separate workspaces

       :editor
       (evil +everywhere); come to the dark side, we have cookies
       file-templates    ; auto-snippets for empty files
       fold              ; (nigh) universal code folding
       (format +onsave)  ; automated prettiness
       multiple-cursors  ; editing in many places at once
       snippets          ; my elves. They type so I don't have to

       :emacs
       dired             ; making dired pretty [functional]
       electric          ; smarter, keyword-based electric-indent
       undo              ; persistent, smarter undo for your inevitable mistakes
       vc                ; version-control and Emacs, sitting in a tree

       :term
       vterm             ; the best terminal emulation in Emacs

       :checkers
       syntax              ; tasing you for every semicolon you forget
       (spell +flyspell) ; tasing you for misspelling mispelling
       grammar           ; tasing grammar mistake every you make

       :tools
       direnv
       docker
       editorconfig      ; let someone else argue about tabs vs spaces
       (eval +overlay)     ; run code, run (also, repls)
       lookup              ; navigate your code and its documentation
       (lsp +peek)               ; M-x vscode
       magit             ; a git porcelain for Emacs
       make              ; run make tasks from Emacs
       pdf               ; pdf enhancements
       tree-sitter       ; syntax and parsing, sitting in a tree...
       (dap +lsp)        ; Debug Adapter Protocol

       :os
       (:if IS-MAC macos)  ; improve compatibility with macOS
       tty               ; improve the terminal Emacs experience

       :lang
       data              ; config/data formats
       emacs-lisp        ; drown in parentheses
       json              ; At least it ain't XML
       (javascript +lsp +tree-sitter)        ; all(hope(abandon(ye(who(enter(here))))))
       markdown          ; writing docs for people to ignore
       (nix +lsp +tree-sitter)               ; I hereby declare "nix geht mehr!"
       org               ; organize your plain life in plain text
       (python +lsp +tree-sitter +pyright)     ; beautiful is better than ugly
       (rust +lsp +tree-sitter)       ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       sh                ; she sells {ba,z,fi}sh shells on the C xor
       (yaml +lsp)              ; JSON, but readable
       (web +lsp +tree-sitter)       ; the tubes
       (cc +lsp +tree-sitter)         ; C > C++ == 1
       (ocaml +lsp +tree-sitter)      ; an ML with a type system that actually helps
       (go +lsp +tree-sitter)         ; the hipster dialect
       (gleam +lsp +tree-sitter)
       (zig +lsp +tree-sitter)        ; C, but simpler
       (elixir +lsp +tree-sitter)            ; erlang done right

       :email

       :app
       calendar

       :config
       (default +bindings +smartparens))