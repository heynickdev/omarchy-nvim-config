-- -- In your lazy.nvim setup (e.g., in lua/plugins/supermaven.lua)
-- return {
--   "supermaven-inc/supermaven-nvim",
--   -- ... other config like 'opts = {...}' ...
--   keys = {
--     {
--       "<leader>cp",
--       "<cmd>SupermavenToggle<cr>",
--       desc = "Toggle Supermaven",
--     },
--     -- Or using the Lua API:
--     -- {
--     --   "<leader>cp",
--     --   function() require("supermaven-nvim.api").toggle() end,
--     --   desc = "Toggle Supermaven"
--     -- },
--   },
-- }
return {
  "supermaven-inc/supermaven-nvim",
  -- ... other config like 'opts = {...}' ...
  keys = {
    -- Use the Lua API function instead of the command
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
  },
}
