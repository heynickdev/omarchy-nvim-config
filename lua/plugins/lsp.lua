return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 1. Svelte Configuration
        svelte = {
          keys = {
            { "<leader>co", "<cmd>SvelteOutline<cr>", desc = "Svelte Outline" },
          },
          settings = {
            svelte = {
              plugin = {
                -- Enables completions for HTML, CSS, and JS/TS within .svelte files
                html = { completions = { enable = true } },
                css = { completions = { enable = true } },
                typescript = {
                  completions = { enable = true },
                  diagnostics = { enable = true },
                },
                -- Optional: Disable the "missing-declaration" warning if using
                -- global types or specific library patterns
                -- hygiene = { enabled = true },
              },
            },
          },
        },

        -- 2. Keep your existing servers so they don't get overwritten
        angularls = { enabled = false },
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
        templ = {},
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
            "svelte", -- Ensure svelte is included for emmet
          },
          init_options = {
            includeLanguages = {
              templ = "html",
              htmldjango = "html",
              svelte = "html",
            },
            showExpandedAbbreviation = "always",
            showAbbreviationSuggestions = true,
          },
        },
      },
    },
  },
}
