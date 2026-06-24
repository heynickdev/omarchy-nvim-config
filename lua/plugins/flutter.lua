return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      "mfussenegger/nvim-dap",
    },
    keys = {
      { "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "Flutter Run" },
      { "<leader>Fd", "<cmd>FlutterDebug<cr>", desc = "Flutter Debug" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Flutter Quit" },
      { "<leader>FR", "<cmd>FlutterReload<cr>", desc = "Flutter Hot Reload" },
      { "<leader>Fs", "<cmd>FlutterRestart<cr>", desc = "Flutter Hot Restart" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Flutter Emulators" },
      { "<leader>FD", "<cmd>FlutterDevices<cr>", desc = "Flutter Devices" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter Outline" },
      { "<leader>Fp", "<cmd>FlutterPubGet<cr>", desc = "Flutter Pub Get" },
      { "<leader>Fl", "<cmd>FlutterLogToggle<cr>", desc = "Flutter Logs" },
    },
    opts = function()
      local platform = require("config.platform")

      return {
        ui = {
          border = "rounded",
        },

        decorations = {
          statusline = {
            app_version = true,
            device = true,
          },
        },

        debugger = {
          enabled = true,
          run_via_dap = true,
        },

        dev_log = {
          enabled = true,
          open_cmd = "botright 15split",
          focus_on_open = false,
          notify_errors = true,
        },

        outline = {
          open_cmd = "30vnew",
          auto_open = false,
        },

        widget_guides = {
          enabled = true,
        },

        closing_tags = {
          enabled = true,
          prefix = ">",
          highlight = "Comment",
        },

        lsp = {
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            enableSnippets = true,
            updateImportsOnRename = true,
            renameFilesWithClasses = "prompt",
            analysisExcludedFolders = {
              platform.pub_cache(),
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("flutter-tools").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "dart",
        "yaml",
        "json",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        dart = { "dart_format" },
      },
    },
  },
}
