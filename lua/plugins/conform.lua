return {
  "stevearc/conform.nvim",
  opts = {
    -- 1. Map your languages to the formatters you've installed
    formatters_by_ft = {
      -- Frontend (Svelte/Nuxt/Vue)
      svelte = { "prettierd" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      vue = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      html = { "prettierd" },
      json = { "prettierd" },

      -- Backend & Databases
      go = { "goimports-reviser", "gofmt" },
      python = { "ruff_organize_imports", "ruff_format" },
      sql = { "pg_format" },
      htmldjango = { "djlint" },

      -- University (C-family / Java)
      c = { "clang_format" },
      cpp = { "clang_format" },
      cs = { "clang_format" },
      java = { "google-java-format" },

      -- Configs
      lua = { "stylua" },
      sh = { "shfmt" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
    },

    -- 2. THE FORMAT ON SAVE TRIGGER
    -- format_on_save = {
    --   -- These options will be passed to conform.format()
    --   timeout_ms = 500,
    --   lsp_format = "fallback", -- Use LSP if specialized formatter isn't found
    -- },

    -- 3. Custom Formatter Rules (Indentation & Capitalization)
    formatters = {
      pg_format = {
        args = { "--spaces", "2", "--keyword-case", "2", "--function-case", "2", "--type-case", "2", "-" },
      },
      clang_format = {
        prepend_args = { "--style={IndentWidth: 2, BasedOnStyle: llvm, BreakBeforeBraces: Attach}" },
      },
      ["goimports-reviser"] = {
        prepend_args = { "-rm-unused", "-set-alias", "-format" },
      },
      shfmt = {
        prepend_args = { "-i", "2", "-ci" },
      },
    },
  },
}
