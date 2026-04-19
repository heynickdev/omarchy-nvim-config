return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 1. Svelte Configuration
        svelte = {
          keys = {
            { "<leader>co", function() Snacks.picker.lsp_symbols() end, desc = "Svelte Outline" },
          },
          settings = {
            svelte = {
              plugin = {
                html = { completions = { enable = true } },
                css = { completions = { enable = true } },
                typescript = {
                  completions = { enable = true },
                  diagnostics = { enable = true },
                },
              },
            },
          },
        },

        -- 2. Go (gopls)
        gopls = {
          settings = {
            gopls = {
              ["formatting.gofumpt"] = false,
            },
          },
          on_attach = function(client, bufnr)
            vim.bo[bufnr].expandtab = true
            vim.bo[bufnr].shiftwidth = 2
            vim.bo[bufnr].softtabstop = 2
            vim.bo[bufnr].tabstop = 2
          end,
        },

        -- 3. Templ
        templ = {},

        -- 4. Emmet
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
            "svelte",
            "vue",
            "templ",
            "htmldjango",
          },
          init_options = {
            includeLanguages = {
              templ = "html",
              htmldjango = "html",
              svelte = "html",
            },
            showExpandedAbbreviation = "always",
            showAbbreviationSuggestions = true,
            showSuggestionsAsSnippets = true,
            html = {
              snippets = {
                form = "form",
              },
            },
          },
        },

        -- 5. ESLint (Optimized with silenced stylistic rules)
        eslint = {
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
            rulesCustomizations = {
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
            },
          },
        },

        -- Disable unwanted servers
        angularls = { enabled = false },
      },
    },
  },
}
