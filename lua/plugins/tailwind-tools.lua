return {
  "luckasRanarison/tailwind-tools.nvim",
  -- This plugin has dependencies that need to be loaded first
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp", -- You already have this from LazyVim
  },
  -- This plugin has a lot of features, so we need a `config` block
  config = function()
    require("tailwind-tools").setup({
      -- This is the part that adds the color hints in your buffer
      tools = {
        color_guide = true, -- Adds virtual text or signs with color previews
      },
      -- This part hooks into nvim-cmp (your autocompleter)
      cmp = {
        -- Set to true to add color swatches to the completion menu
        color_guide = true,
      },
      -- This ensures it works in your React/Next.js files
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "html",
        "css",
        "templ",
        "go", -- For templ
      },
    })
  end,
}
