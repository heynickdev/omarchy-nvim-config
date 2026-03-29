return {
  "stevearc/conform.nvim",
  opts = {
    -- 1. Added C, C++, and C# support (useful for university)
    formatters_by_ft = {
      sql = { "pg_format" },
      htmldjango = { "djlint" },
      cpp = { "clang_format" },
      c = { "clang_format" },
      cs = { "clang_format" },
    },

    -- 2. Configure capitalization and formatting rules
    formatters = {
      pg_format = {
        args = {
          "--spaces",
          "2", -- 2 spaces indentation
          "--keyword-case",
          "2", -- Capitalize Keywords (SELECT)
          "--function-case",
          "2", -- Capitalize Functions (COUNT)
          "--type-case",
          "2", -- Capitalize Types (UUID, INT)
          "-", -- Read from stdin
        },
      },
      -- Customizing clang-format behavior globally
      clang_format = {
        prepend_args = {
          "--style={IndentWidth: 4, BasedOnStyle: llvm, BreakBeforeBraces: Attach}",
        },
      },
    },
    -- 3. Ensure format on save is active
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },
  },
}
