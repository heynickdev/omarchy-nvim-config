return {
  {
    "mfussenegger/nvim-dap",

    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "DAP Continue",
      },
      {
        "<leader>dq",
        function()
          require("dap").terminate()
        end,
        desc = "DAP Terminate",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "DAP REPL Toggle",
      },
    },

    config = function()
      local dap = require("dap")

      dap.set_log_level("WARN")

      -- Do not stop inside Dart/Flutter SDK exception internals by default.
      dap.defaults.fallback.exception_breakpoints = {}
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    optional = true,

    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },

    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "DAP UI Toggle",
      },
    },

    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.35 },
            { id = "breakpoints", size = 0.20 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.20 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
        },
      },
    },

    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)

      -- This is the part that stops all those panes from opening automatically.
      dap.listeners.after.event_initialized["dapui_config"] = nil
      dap.listeners.before.event_terminated["dapui_config"] = nil
      dap.listeners.before.event_exited["dapui_config"] = nil

      -- Keep DAP UI manual only.
      -- Open it yourself with <leader>du.
    end,
  },
}
