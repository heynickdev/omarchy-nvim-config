return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Configuration for the modern 'emmet-language-server'
        emmet_language_server = {
          filetypes = {
            "css",
            "eruby",
            "html",
            "javascript",
            "javascriptreact",
            "less",
            "sass",
            "scss",
            "pug",
            "typescriptreact",
            "vue",
            "templ", 
            "htmldjango"
          },
          init_options = {
            includeLanguages = {
              templ = "html",
              htmldjango = "html",
            },
            showExpandedAbbreviation = "always",
            showAbbreviationSuggestions = true,
            -- Define custom snippets to override defaults
            html = {
              snippets = {
                -- Override 'form' to be just the tag, effectively removing action=""
                form = "form",
              },
            },
          },
        },

        -- Fallback configuration if you are using the older 'emmet_ls'
        emmet_ls = {
          filetypes = {
            "css",
            "eruby",
            "html",
            "javascript",
            "javascriptreact",
            "less",
            "sass",
            "scss",
            "pug",
            "typescriptreact",
            "vue",
            "templ",
            "htmldjango",
          },
          init_options = {
            includeLanguages = {
              templ = "html",
              htmldjango = "html",
            },
            html = {
              snippets = {
                form = "form",
              },
            },
          },
        },
      },
    },
  },
}
