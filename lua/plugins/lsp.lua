return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Explicitly disabled
      angularls = {
        enabled = false,
      },

      -- Enable templ support
      templ = {},

      -- Emmet with expanded abbreviation suggestions and language mapping
      emmet_language_server = {
        filetypes = {
          "css",
          "eruby",
          "html",
          "htmldjango",
          "javascript",
          "javascriptreact",
          "less",
          "pug",
          "sass",
          "scss",
          "svelte",
          "templ",
          "typescriptreact",
          "vue", -- Added for Nuxt 4 support
        },
        init_options = {
          includeLanguages = {
            templ = "html",
            htmldjango = "html",
            svelte = "html",
            vue = "html", -- Ensures HTML expansions work smoothly in Vue templates
          },
        },
      },

      -- gopls settings to ignore gofumpt formatting
      gopls = {
        settings = {
          gopls = {
            gofumpt = false,
          },
        },
      },
    },

    setup = {
      gopls = function(_, _)
        -- Hook into the gopls attachment process
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == "gopls" then
              -- Strip gopls of its formatting capabilities so conform.nvim has full control
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false

              -- Strictly enforce 4 spaces for Go buffers
              vim.bo[args.buf].expandtab = true
              vim.bo[args.buf].shiftwidth = 4
              vim.bo[args.buf].tabstop = 4
              vim.bo[args.buf].softtabstop = 4
            end
          end,
        })
        -- Return false so the base framework still handles the core server initialization
        return false
      end,
    },
  },
}
