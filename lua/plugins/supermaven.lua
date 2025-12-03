-- return {
--   "supermaven-inc/supermaven-nvim",
--   -- ... other config like 'opts = {...}' ...
--   keys = {
--     -- Use the Lua API function instead of the command
--     {
--       "<leader>cp",
--       function()
--         local supermaven = require("supermaven-nvim.api")
--         local is_running = supermaven.is_running()
--         supermaven.toggle()
--
--         -- Check the state *before* the toggle to determine the *new* state
--         local new_state_msg = is_running and "Disabled" or "Enabled"
--         vim.notify("Supermaven " .. new_state_msg, vim.log.levels.INFO, { title = "Supermaven" })
--       end,
--       desc = "Toggle Supermaven",
--     },
--     accept_word = "<C-l>",
--   },
--   disable_keymaps = true,
-- }


return {
  "supermaven-inc/supermaven-nvim",
  -- 1. Ensure the plugin is always loaded (VeryLazy) so the Lua API is ready for the keymap.
  -- You could also use 'lazy = false' but 'VeryLazy' is generally better for startup time.
  event = "VeryLazy",
  
  -- 2. Use the 'config' function to run a command immediately after setup is complete.
  config = function(_, opts)
    -- Call the default setup function
    require("supermaven-nvim").setup(opts)
    
    -- 🛑 CRITICAL STEP: Immediately stop the service after it starts up
    -- This ensures it is DISABLED on load, fulfilling your primary requirement.
    local supermaven = require("supermaven-nvim.api")
    if supermaven.is_running() then
      supermaven.stop()
    end
  end,

  -- We keep 'opts = {}' empty or add any other non-startup-related options here
  opts = {
    -- The 'disable_on_startup' option is not officially supported and is ignored,
    -- but you can add other options here, like filetype ignores, etc.
    keymaps = {
            accept_suggestion = false,

        },
  },

  keys = {
    -- 3. Your keymap can now reliably use the Lua API
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
    -- Keep your custom keymap for accepting word
    accept_suggestion = "<C-l>",
  },
  
  disable_keymaps = true, -- Retained from your snippet
}
