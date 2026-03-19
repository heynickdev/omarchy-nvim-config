return {
  -- 1. Make the default Tokyonight theme transparent
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  
  -- 2. Force transparency across all UI elements (like Telescope and NeoTree)
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      require("transparent").setup({
        extra_groups = {
          "NormalFloat",
          "NvimTreeNormal",
          "NeoTreeNormal",
          "NeoTreeNormalNC",
          "TelescopeNormal",
          "TelescopeBorder",
          "WhichKeyFloat",
        },
      })
      -- Automatically clear backgrounds on load
      vim.cmd("TransparentEnable")
    end,
  }
}
