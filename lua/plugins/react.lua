return {
  "justYu2001/react.nvim",
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    require("react").setup()
  end,
}
