return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")

      npairs.setup({
        check_ts = true, -- Enable treesitter integration
        map_c_h = true, -- Map the <C-h> key to delete a pair
        map_c_w = true, -- map <c-w> to delete a pair if possible
      })

      -- Remove the default rule for < to stop the conflict/glitch
      npairs.remove_rule("<")

      -- REMOVED the problematic vim.keymap.set for ">"
    end,
  },

  -- Ensure autotag is still running for closing HTML tags (e.g., typing </div>)
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      })
    end,
  },
}
