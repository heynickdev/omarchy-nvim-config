return {
  -- 1. Your custom ESLint LSP configuration
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local lspconfig = require("lspconfig")

      -- Define the customizations to silence style rules but keep them fixable
      local customizations = {
        { rule = "style/*", severity = "off", fixable = true },
        { rule = "format/*", severity = "off", fixable = true },
        { rule = "*-indent", severity = "off", fixable = true },
        { rule = "*-spacing", severity = "off", fixable = true },
        { rule = "*-spaces", severity = "off", fixable = true },
        { rule = "*-order", severity = "off", fixable = true },
        { rule = "*-dangle", severity = "off", fixable = true },
        { rule = "*-newline", severity = "off", fixable = true },
        { rule = "*quotes", severity = "off", fixable = true },
        { rule = "*semi", severity = "off", fixable = true },
      }

      -- Setup ESLint
      lspconfig.eslint.setup({
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "vue",
          "html",
          "markdown",
          "json",
          "jsonc",
          "yaml",
          "toml",
          "xml",
          "gql",
          "graphql",
          "astro",
          "svelte",
          "css",
          "less",
          "scss",
          "pcss",
          "postcss",
        },
        settings = {
          -- Silent the stylistic rules in your IDE, but still auto fix them
          rulesCustomizations = customizations,
        },
      })
    end,
  },

  -- 2. Configure LazyVim's formatter (conform.nvim) to use ESLint for Vue files
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- This maps the standard LazyVim format action to ESLint for .vue files
        -- vue = { "eslint" },

        -- You can easily add other filetypes here later if needed, for example:
        -- javascript = { "eslint" },
        -- typescript = { "eslint" },
      },
    },
  },
}
