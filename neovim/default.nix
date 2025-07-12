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

    diagnostic.settings = {
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
      dap = {
        enable = true;
        # Configure the debug adapters for each language
        adapters = {
          # "pwa-node" = {
          #   type = "server";
          #   port = "8008";
          # Corrected package path for the JS/TS debugger
          #   executable.command = "${pkgs.vscode-js-debug}/bin/js-debug";
          #   executable.args = [ "8008" ];
          # };
          # go = {
          #   type = "server";
          #   port = "\${port}";
          #  executable.command = "${pkgs.delve}/bin/dlv";
          # executable.args = [
          #   "dap"
          #   "-l"
          #   "127.0.0.1:\${port}"
          # ];
          #};
          #ocaml = {
          #  type = "executable";
          #  command = "${pkgs.vscode-extensions.ocamllabs.ocaml-platform}/bin/ocamlearlybird";
          #  args = [ "debug" ];
          #};
          #codelldb = {

          # type = "server";
          # port = "\${port}";
          # Corrected package path for the codelldb adapter
          # executable.command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/bin/codelldb";
          # executable.args = [
          #   "--port"
          #   "\${port}"
          # ];
          #};
        };
      };
      dap-ui.enable = true;

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
      {
        key = "<leader>db";
        action = "<cmd>DapToggleBreakpoint<cr>";
        mode = "n";
        options.desc = "Toggle Breakpoint";
      }
      {
        key = "<leader>dc";
        action = "<cmd>DapContinue<cr>";
        mode = "n";
        options.desc = "Continue";
      }
      {
        key = "<leader>do";
        action = "<cmd>DapStepOver<cr>";
        mode = "n";
        options.desc = "Step Over";
      }
      {
        key = "<leader>di";
        action = "<cmd>DapStepInto<cr>";
        mode = "n";
        options.desc = "Step Into";
      }
      {
        key = "<leader>du";
        action = "<cmd>DapStepOut<cr>";
        mode = "n";
        options.desc = "Step Out";
      }
      {
        key = "<leader>dr";
        action = "<cmd>DapToggleRepl<cr>";
        mode = "n";
        options.desc = "Toggle REPL";
      }
      {
        key = "<leader>dl";
        action = "<cmd>DapRunLast<cr>";
        mode = "n";
        options.desc = "Run Last";
      }
      {
        key = "<leader>dt";
        action = "<cmd>DapTerminate<cr>";
        mode = "n";
        options.desc = "Terminate";
      }
    ];
  };
}
