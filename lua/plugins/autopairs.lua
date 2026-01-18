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

      -- 1. Remove the default rule for < to stop the conflict/glitch
      npairs.remove_rule("<")

      -- 2. Custom Keymap: Create the "Middle" behavior
      -- Logic: If I type '>', check if the previous char is '<'.
      -- If yes: Convert it to <|> (middle).
      -- If no: Just type >.
      for _, mode in pairs({ "i" }) do
        vim.keymap.set(mode, ">", function()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local line = vim.api.nvim_get_current_line()
          local char_before = line:sub(col, col)

          if char_before == "<" then
            -- We just typed <, and now we typed >.
            -- Action: Insert > and move cursor Left.
            return "><Left>"
          else
            -- Normal behavior
            return ">"
          end
        end, { expr = true, noremap = true, buffer = false })
      end
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
