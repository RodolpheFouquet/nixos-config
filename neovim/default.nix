{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = false;

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
      enable = false;
    };

    colorschemes.tokyonight = {
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
      web-devicons.enable = true;

      treesitter = {
        enable = true;
        nixGrammars = true;
        ensureInstalled = [
          "nix"
          "python"
          "rust"
          "gleam"
          "go"
          "typescript"
          "javascript"
          "lua"
          "zig"
          "elixir"
          "ocaml"
          "c"
          "cpp"
          "markdown"
          "markdown_inline"
          "bash"
        ];
        settings = {
          highlight = {
            enable = true;
          };
          indent = {
            enable = true;
          };
        };
      };

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
          clangd.enable = true;
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
          gleam = [ "gleam" ];
          go = [ "gofmt" ];
          typescript = [ "prettier" ];
          elixir = [ "mix" ];
          zig = [ "zig" ];
        };
      };

      # DAP Configuration
      dap = {
        enable = true;
        # Adapters and configurations will be set up in extraConfigLua
      };

      # DAP UI and extensions
      dap-ui = {
        enable = true;
        # Configuration will be handled in extraConfigLua
      };

      # Language-specific DAP plugins
      dap-python = {
        enable = true;
        # Remove the adapter line - dap-python sets this up automatically
      };
      dap-go.enable = true;
      dap-virtual-text.enable = true;

      # Telescope
      telescope = {
        enable = true;
        # DAP extension will be configured in extraConfigLua
      };

      # Harpoon
      harpoon = {
        enable = true;
        enableTelescope = true;
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

      # Harpoon keymaps
      {
        key = "<leader>a";
        action = "<cmd>lua require('harpoon.mark').add_file()<cr>";
        mode = "n";
        options.desc = "Harpoon Add File";
      }
      {
        key = "<C-e>";
        action = "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>";
        mode = "n";
        options.desc = "Harpoon Quick Menu";
      }
      {
        key = "<C-h>";
        action = "<cmd>lua require('harpoon.ui').nav_file(1)<cr>";
        mode = "n";
        options.desc = "Harpoon File 1";
      }
      {
        key = "<C-j>";
        action = "<cmd>lua require('harpoon.ui').nav_file(2)<cr>";
        mode = "n";
        options.desc = "Harpoon File 2";
      }
      {
        key = "<C-k>";
        action = "<cmd>lua require('harpoon.ui').nav_file(3)<cr>";
        mode = "n";
        options.desc = "Harpoon File 3";
      }
      {
        key = "<C-l>";
        action = "<cmd>lua require('harpoon.ui').nav_file(4)<cr>";
        mode = "n";
        options.desc = "Harpoon File 4";
      }

      # DAP keymaps
      {
        key = "<leader>db";
        action = "<cmd>DapToggleBreakpoint<cr>";
        mode = "n";
        options.desc = "Toggle Breakpoint";
      }
      {
        key = "<leader>dB";
        action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>";
        mode = "n";
        options.desc = "Set Conditional Breakpoint";
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
      {
        key = "<leader>dui";
        action = "<cmd>lua require('dapui').toggle()<cr>";
        mode = "n";
        options.desc = "Toggle DAP UI";
      }

      # Telescope DAP keymaps
      {
        key = "<leader>dcc";
        action = "<cmd>Telescope dap commands<cr>";
        mode = "n";
        options.desc = "DAP Commands";
      }
      {
        key = "<leader>dco";
        action = "<cmd>Telescope dap configurations<cr>";
        mode = "n";
        options.desc = "DAP Configurations";
      }
      {
        key = "<leader>dv";
        action = "<cmd>Telescope dap variables<cr>";
        mode = "n";
        options.desc = "DAP Variables";
      }
      {
        key = "<leader>df";
        action = "<cmd>Telescope dap frames<cr>";
        mode = "n";
        options.desc = "DAP Frames";
      }
    ];

    # Additional Lua configuration for DAP
    extraConfigLua = ''
      local dap = require('dap')
      local dapui = require('dapui')
      local telescope = require('telescope')

      -- Configure DAP UI
      dapui.setup({
        icons = {
          expanded = "▾",
          collapsed = "▸",
          current_frame = "▸"
        },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t"
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches"
            },
            size = 40,
            position = "left"
          },
          {
            elements = {
              "repl",
              "console"
            },
            size = 0.25,
            position = "bottom"
          }
        }
      })

      -- Load telescope DAP extension
      telescope.load_extension('dap')

      -- Configure debug adapters
      require('dap-go').setup()
      dap.adapters.pwa_node = {
        type = "server",
        host = "localhost",
        port = 8123,
        executable = {
          command = "${pkgs.vscode-js-debug}/bin/js-debug",
          args = { "8123" }
        }
      }

      dap.adapters.codelldb = {
        type = "server",
        port = "''${port}",
        executable = {
          command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb",
          args = { "--port", "''${port}" }
        }
      }

      dap.adapters.python = {
        type = "executable",
        command = "${pkgs.python3Packages.debugpy}/bin/python",
        args = { "-m", "debugpy.adapter" }
      }

      dap.adapters.ocamlearlybird = {
        type = "server",
        host = "127.0.0.1",
        port = 5859
      }

      -- Auto-open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- All DAP configurations with dynamic input
      dap.configurations.rust = {
        {
          name = 'Launch Rust',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
          end,
          cwd = vim.fn.getcwd(),
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
      }

      dap.configurations.c = {
        {
          name = 'Launch C',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = vim.fn.getcwd(),
          stopOnEntry = false,
          args = {},
        },
      }

      dap.configurations.cpp = dap.configurations.c

      dap.configurations.python = {
        {
          name = 'Launch Python',
          type = 'python',
          request = 'launch',
          program = vim.fn.expand('%:p'),
          console = 'integratedTerminal',
          cwd = vim.fn.getcwd(),
        },
        {
          name = 'Launch Python with args',
          type = 'python',
          request = 'launch',
          program = vim.fn.expand('%:p'),
          args = function()
            local args_string = vim.fn.input('Arguments: ')
            return vim.split(args_string, " ", true)
          end,
          console = 'integratedTerminal',
          cwd = vim.fn.getcwd(),
        },
      }

      dap.configurations.ocaml = {
        {
          name = 'OCaml Debug',
          type = 'ocamlearlybird',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/_build/default/', 'file')
          end,
          cwd = vim.fn.getcwd(),
          stopOnEntry = false,
          console = 'integratedTerminal',
          yieldSteps = 4096,
        },
      }

      dap.configurations.zig = {
        {
          name = 'Launch Zig',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/zig-out/bin/', 'file')
          end,
          cwd = vim.fn.getcwd(),
          stopOnEntry = false,
          args = {},
        },
      }

      dap.configurations.typescript = {
        {
          name = 'Launch Node.js',
          type = 'pwa-node',
          request = 'launch',
          program = vim.fn.expand('%:p'),
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = 'inspector',
          console = 'integratedTerminal',
        },
        {
          name = 'Attach to Node.js',
          type = 'pwa-node',
          request = 'attach',
          port = 9229,
          restart = true,
          sourceMaps = true,
          cwd = vim.fn.getcwd(),
        },
      }

      dap.configurations.javascript = {
        {
          name = 'Launch Node.js',
          type = 'pwa-node',
          request = 'launch',
          program = vim.fn.expand('%:p'),
          cwd = vim.fn.getcwd(),
          console = 'integratedTerminal',
        },
      }
    '';

    extraPackages = with pkgs; [
      vscode-js-debug
      python3Packages.debugpy
      delve # Go debugger
      vscode-extensions.vadimcn.vscode-lldb
      ocamlPackages.earlybird
    ];

    extraPlugins = with pkgs.vimPlugins; [
      telescope-dap-nvim
    ];
  };
}
