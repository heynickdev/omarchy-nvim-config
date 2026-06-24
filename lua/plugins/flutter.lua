local function is_flutter_log_buf(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  if not vim.api.nvim_buf_is_loaded(buf) then
    return false
  end

  local name = vim.api.nvim_buf_get_name(buf)
  local basename = vim.fn.fnamemodify(name, ":t")
  local filetype = vim.bo[buf].filetype

  return basename == "__FLUTTER_DEV_LOG__"
    or name:find("__FLUTTER_DEV_LOG__", 1, true) ~= nil
    or filetype:lower():find("flutter") ~= nil and filetype:lower():find("log") ~= nil
end

local function find_flutter_log_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if is_flutter_log_buf(buf) then
      return buf
    end
  end

  return nil
end

local function close_flutter_log_windows()
  local closed = false

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)

    if is_flutter_log_buf(buf) then
      pcall(vim.api.nvim_win_close, win, true)
      closed = true
    end
  end

  return closed
end

local function open_flutter_log_buf(buf)
  vim.cmd("botright 15split")
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_win_set_height(0, 15)

  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
end

local function toggle_flutter_logs()
  -- If any Flutter log window is visible, hide all of them.
  if close_flutter_log_windows() then
    return
  end

  -- If the log buffer already exists but is hidden, show that exact buffer.
  local buf = find_flutter_log_buf()

  if buf then
    open_flutter_log_buf(buf)
    return
  end

  -- If Flutter has not created the log buffer yet, ask flutter-tools to open it.
  vim.cmd("FlutterLogToggle")
end

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

      {
        "<leader>Ft",
        toggle_flutter_logs,
        desc = "Toggle Flutter Logs",
        mode = { "n", "t" },
      },

      { "<leader>Fc", "<cmd>FlutterLogClear<cr>", desc = "Clear Flutter Logs" },

      { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Flutter Emulators" },
      { "<leader>FD", "<cmd>FlutterDevices<cr>", desc = "Flutter Devices" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter Outline" },
      { "<leader>Fp", "<cmd>FlutterPubGet<cr>", desc = "Flutter Pub Get" },
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
