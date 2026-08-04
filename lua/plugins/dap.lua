local function remove_old_debug_keys(keys)
  local filtered = {}

  for _, key in ipairs(keys or {}) do
    local lhs = key[1]
    local is_old_debug_key = type(lhs) == "string" and (lhs:match("^<leader>d") ~= nil or lhs:match("^d") ~= nil)

    if not is_old_debug_key then
      table.insert(filtered, key)
    end
  end

  return filtered
end

local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  local args_string = type(args) == "table" and table.concat(args, " ") or args

  config = vim.deepcopy(config)
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_string))

    if config.type == "java" then
      return new_args
    end

    return require("dap.utils").splitstr(new_args)
  end

  return config
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Installs the VSCode JS debugger adapter inside Neovim.
      {
        "mxsdev/nvim-dap-vscode-js",
        opts = {
          debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
          adapters = { "pwa-node", "pwa-chrome" },
        },
      },
    },

    -- Remove every old debugger mapping under d/<leader>d and expose the
    -- debugger under <leader>z instead.
    keys = function(_, keys)
      keys = remove_old_debug_keys(keys)

      vim.list_extend(keys, {
        {
          "<leader>zB",
          function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "DAP Conditional Breakpoint",
        },
        {
          "<leader>zb",
          function()
            require("dap").toggle_breakpoint()
          end,
          desc = "DAP Toggle Breakpoint",
        },
        {
          "<leader>zc",
          function()
            require("dap").continue()
          end,
          desc = "DAP Run/Continue",
        },
        {
          "<leader>za",
          function()
            require("dap").continue({ before = get_args })
          end,
          desc = "DAP Run with Arguments",
        },
        {
          "<leader>zC",
          function()
            require("dap").run_to_cursor()
          end,
          desc = "DAP Run to Cursor",
        },
        {
          "<leader>zg",
          function()
            require("dap").goto_()
          end,
          desc = "DAP Go to Line",
        },
        {
          "<leader>zi",
          function()
            require("dap").step_into()
          end,
          desc = "DAP Step Into",
        },
        {
          "<leader>zj",
          function()
            require("dap").down()
          end,
          desc = "DAP Stack Down",
        },
        {
          "<leader>zk",
          function()
            require("dap").up()
          end,
          desc = "DAP Stack Up",
        },
        {
          "<leader>zl",
          function()
            require("dap").run_last()
          end,
          desc = "DAP Run Last",
        },
        {
          "<leader>zo",
          function()
            require("dap").step_out()
          end,
          desc = "DAP Step Out",
        },
        {
          "<leader>zO",
          function()
            require("dap").step_over()
          end,
          desc = "DAP Step Over",
        },
        {
          "<leader>zP",
          function()
            require("dap").pause()
          end,
          desc = "DAP Pause",
        },
        {
          "<leader>zq",
          function()
            require("dap").terminate()
          end,
          desc = "DAP Terminate",
        },
        {
          "<leader>zr",
          function()
            require("dap").repl.toggle()
          end,
          desc = "DAP REPL Toggle",
        },
        {
          "<leader>zs",
          function()
            require("dap").session()
          end,
          desc = "DAP Session",
        },
        {
          "<leader>zw",
          function()
            require("dap.ui.widgets").hover()
          end,
          desc = "DAP Widgets",
        },
      })

      return keys
    end,

    config = function()
      local dap = require("dap")

      dap.set_log_level("WARN")

      -- Do not stop inside Dart/Flutter SDK exception internals by default.
      dap.defaults.fallback.exception_breakpoints = {}

      -- React Native / Expo debugging.
      local expo_config = {
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Metro (Expo / React Native)",
          port = 8081,
          sourceMaps = true,
          trace = true,
          cwd = vim.fn.getcwd(),
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        },
      }

      dap.configurations.javascriptreact = expo_config
      dap.configurations.typescriptreact = expo_config
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    optional = true,

    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },

    keys = function(_, keys)
      keys = remove_old_debug_keys(keys)

      vim.list_extend(keys, {
        {
          "<leader>zu",
          function()
            require("dapui").toggle()
          end,
          desc = "DAP UI Toggle",
        },
        {
          "<leader>ze",
          function()
            require("dapui").eval()
          end,
          mode = { "n", "x" },
          desc = "DAP Evaluate",
        },
      })

      return keys
    end,

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
          orientation = "vertical",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
          orientation = "horizontal",
        },
      },
    },

    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)

      -- Keep DAP UI manual only.
      dap.listeners.after.event_initialized["dapui_config"] = nil
      dap.listeners.before.event_terminated["dapui_config"] = nil
      dap.listeners.before.event_exited["dapui_config"] = nil
    end,
  },
}
