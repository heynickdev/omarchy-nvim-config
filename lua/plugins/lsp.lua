return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Existing servers
        angularls = { enabled = false },
        gopls = {
          settings = {
            gopls = {
              -- This helps gopls understand how to handle whitespace during refactoring
              ["formatting.gofumpt"] = false, -- gofumpt often forces tabs even harder
            },
          },
          -- This forces the buffer to use spaces whenever a Go file is opened via LSP
          on_attach = function(client, bufnr)
            vim.bo[bufnr].expandtab = true
            vim.bo[bufnr].shiftwidth = 2
            vim.bo[bufnr].softtabstop = 2
            vim.bo[bufnr].tabstop = 2
          end,
        },

        -- 1. Enable Templ LSP
        templ = {},

        -- 2. Configure Emmet to work with Templ and Django
        emmet_language_server = {
          filetypes = {
            "html",
            "typescriptreact",
            "javascriptreact",
            "css",
            "sass",
            "scss",
            "less",
            "templ",
            "htmldjango",
            "go",
          },
          init_options = {
            includeLanguages = {
              templ = "html",
              htmldjango = "html",
            },
            showExpandedAbbreviation = "always",
            showAbbreviationSuggestions = true,
          },
        },
      },
    },
  },
}
