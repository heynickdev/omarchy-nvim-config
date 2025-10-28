-- In your lazy.nvim setup (e.g., in lua/plugins/supermaven.lua)
return {
  "supermaven-inc/supermaven-nvim",
  -- ... other config like 'opts = {...}' ...
  keys = {
    {
      "<leader>cp",
      "<cmd>SupermavenToggle<cr>",
      desc = "Toggle Supermaven",
    },
    -- Or using the Lua API:
    -- {
    --   "<leader>cp",
    --   function() require("supermaven-nvim.api").toggle() end,
    --   desc = "Toggle Supermaven"
    -- },
  },
}
