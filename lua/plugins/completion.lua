return {
  -- 1. CONFIGURE SUPERMAVEN
  {
    "supermaven-inc/supermaven-nvim",
    -- 1. Ensure the plugin is always loaded (VeryLazy) so the Lua API is ready for the keymap.
    event = "VeryLazy",

    -- 2. Use the 'config' function to run a command immediately after setup is complete.
    config = function(_, opts)
      -- Call the default setup function
      require("supermaven-nvim").setup(opts)
      -- 🛑 CRITICAL STEP: Immediately stop the service after it starts up
      -- This ensures it is DISABLED on load, fulfilling your primary requirement.
      vim.defer_fn(function()
        vim.cmd("SupermavenUseFree")
      end, 100)
      local supermaven = require("supermaven-nvim.api")
      if supermaven.is_running() then
        supermaven.stop()
      end
    end,

    opts = {
      keymaps = {
        -- Disable the default <Tab> mapping for supermaven
        accept_suggestion = false,
      },
    },

    keys = {
      -- Custom Toggle Keymap
      {
        "<leader>cp",
        function()
          local supermaven = require("supermaven-nvim.api")
          local is_running = supermaven.is_running()
          supermaven.toggle()

          -- Check the state *before* the toggle to determine the *new* state
          local new_state_msg = is_running and "Disabled" or "Enabled"
          vim.notify("Supermaven " .. new_state_msg, vim.log.levels.INFO, { title = "Supermaven" })
        end,
        desc = "Toggle Supermaven",
      },
      -- Accept with Ctrl+L (also closes blink.cmp)
      {
        "<C-l>",
        function()
          local sm = require("supermaven-nvim.completion_preview")
          if sm.has_suggestion() then
            -- Accept the Supermaven suggestion
            sm.on_accept_suggestion()

            -- Use blink.cmp's API to close the popup
            require("blink.cmp").hide()
          end
        end,
        mode = "i",
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
