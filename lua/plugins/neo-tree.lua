return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },

  keys = {
    -- <leader>e = Neo-tree
    {
      "<leader>e",
      function()
        vim.cmd("Neotree toggle reveal")
      end,
      desc = "Toggle Neo-tree",
    },

    -- Stop Neo-tree/LazyVim from using <leader>E
    {
      "<leader>E",
      false,
    },
  },

  config = function()
    require("neo-tree").setup({
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      filesystem = {
        -- This is the important bit:
        -- Neo-tree will NOT hijack :Explore, :Sexplore, :Vexplore, :Lexplore
        hijack_netrw_behavior = "disabled",

        follow_current_file = {
          enabled = true,
        },

        use_libuv_file_watcher = true,
      },

      -- Enables line numbers inside Neo-tree
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
