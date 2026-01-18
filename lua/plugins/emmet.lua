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
            "templ", -- Added templ since you mentioned you use it
          },
          init_options = {
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
          },
          init_options = {
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
