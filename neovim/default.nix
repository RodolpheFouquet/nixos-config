{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    opts = {
      number = true;
      relativenumber = true;
      mouse = "";
      clipboard = "unnamedplus";
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
    };

    colorschemes.gruvbox = {
      enable = true;
    };

    diagnostics = {
      virtualText = {
        enable = true;
        # Show virtual text for warnings and errors
        severityMin = "Warn";
      };
      signs.enable = true;
      underline.enable = true;
    };

    plugins = {
      lualine.enable = true;
      telescope.enable = true;
      web-devicons.enable = true;
      lsp = {
        enable = true;
        inlayHints = true;
        keymaps.lspBuf = {
          "gd" = "definition";
          "gD" = "declaration";
          "gr" = "references";
          "gi" = "implementation";
          "K" = "hover";
          "ca" = "code_action";
        };
        servers = {
          nixd.enable = true;
          pyright.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          ocamllsp.enable = true;
          gleam.enable = true;
          gopls.enable = true;
          ts_ls.enable = true;
          elixirls.enable = true;
          zls.enable = true;
        };
      };

      conform-nvim = {
        enable = true;
        settings.format_on_save = {
          lsp_fallback = true;
          timeout_ms = 500;
        };
        settings.formatters_by_ft = {
          nix = [ "nixfmt" ];
          python = [ "ruff_format" ];
          rust = [ "rustfmt" ];
          ocaml = [ "ocamlformat" ];
          gleam = [ "gleam" ];
          go = [ "gofmt" ];
          typescript = [ "prettier" ];
          elixir = [ "mix" ];
          zig = [ "zig" ];
        };
      };
    };

    globals.mapleader = " ";

    keymaps = [
      {
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        mode = "n";
        options.desc = "Find Files";
      }
      {
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        mode = "n";
        options.desc = "Live Grep";
      }
    ];
  };
}
