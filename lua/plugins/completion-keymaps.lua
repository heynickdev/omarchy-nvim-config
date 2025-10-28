return {
  -- 1. CONFIGURE SUPERMAVEN
  {
    "supermaven-inc/supermaven-nvim",
    opts = {
      keymaps = {
        -- Disable the default <Tab> mapping for supermaven
        accept_suggestion = false,
      },
    },
    -- Use LazyVim's 'keys' table to add our custom mapping
    keys = {
      {
        "<C-l>", -- Goal: Accept with Ctrl+L
        function()
          local sm = require("supermaven-nvim.completion_preview")
          if sm.has_suggestion() then
            -- Accept the Supermaven suggestion
            sm.on_accept_suggestion()

            -- **THE FIX**: Use blink.cmp's API to close the popup
            require("blink.cmp").hide()
          end
        end,
        mode = "i", -- Only run in Insert mode
        desc = "Supermaven: Accept Suggestion",
      },
    },
  },

  -- 2. CONFIGURE BLINK.CMP (the new nvim-cmp)
  {
    "saghen/blink.cmp",
    opts = {
      -- This 'keymap' table overrides the blink.cmp defaults
      keymap = {
        -- Goal: Stop Enter from accepting.
        -- We map <CR> to "cancel" the completion and "fallback"
        -- to its default behavior (inserting a newline).
        ["<CR>"] = { "cancel", "fallback" },

        -- Goal: Accept with Tab
        -- "accept" will confirm the selection
        ["<Tab>"] = { "accept", "fallback" },

        -- Goal: Go up and down the items
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },

        -- Keep other sensible defaults
        ["<C-Space>"] = { "show" }, -- Manually trigger completion
        ["<C-e>"] = { "hide" }, -- Close the completion menu
      },
    },
  },
}
