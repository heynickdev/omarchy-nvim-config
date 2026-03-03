-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Existing servers
        angularls = { enabled = false },
        gopls = {},

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
