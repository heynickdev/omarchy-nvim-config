return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    close_if_last_window = false,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = false, -- Disabled to prevent crashes with Svelte diagnostics

    filesystem = {
      use_libuv_file_watcher = false, -- Disabled to improve stability in Svelte projects
      filtered_items = {
        visible = false, -- Shows hidden files by default
        hide_dotfiles = true, -- Keeps dotfiles in the "filtered" group so 'H' can toggle them
        hide_gitignored = true, -- Keeps gitignored files in the "filtered" group
        hide_by_name = {
          ".DS_Store",
          "thumbs.db",
          "node_modules",
          ".svelte-kit",
        },
      },
      follow_current_file = {
        enabled = true, -- Enable following current file safely
        leave_dirs_open = false,
      },
    },

    -- This block enables the line numbers
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(_)
          vim.opt_local.number = true
          vim.opt_local.relativenumber = true
        end,
      },
    },
  },
}
