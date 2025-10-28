return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(args)
            -- These set the options *only* for the neo-tree window
            vim.opt_local.number = true
            vim.opt_local.relativenumber = true
          end,
        },
      },
    },
  },
}
