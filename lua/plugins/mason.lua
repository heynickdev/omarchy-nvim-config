return {
  {
    "mason-org/mason.nvim",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local mason_tool_installer = require("mason-tool-installer")

      -- Enable mason and configure icons
      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      -- Auto-install these Language Servers
      mason_lspconfig.setup({
        ensure_installed = {
          "clangd", -- C/C++
          "omnisharp", -- C# / .NET
          "gopls", -- Go
          "ts_ls", -- TypeScript/JavaScript
          "vue_ls", -- Vue / Nuxt (UPDATED NAME)
          "svelte", -- Svelte
          "tailwindcss", -- Tailwind CSS
          "pyright", -- Python
          "rust_analyzer", -- Rust
          "jdtls", -- Java
        },
        automatic_installation = true,
      })

      -- Auto-install these formatters and linters
      mason_tool_installer.setup({
        ensure_installed = {
          "prettierd", -- Web ecosystem formatter
          "gofumpt", -- Go formatter
          "stylua", -- Lua formatter
          "black", -- Python formatter
        },
      })
    end,
  },
}
