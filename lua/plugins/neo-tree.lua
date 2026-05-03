return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      filesystem = {
        filtered_items = {
          visible = true, -- Shows hidden files by default
          hide_dotfiles = true, -- Keeps dotfiles in the "filtered" group so 'H' can toggle them
          hide_gitignored = true, -- Keeps gitignored files in the "filtered" group
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
    })
  end,
}
