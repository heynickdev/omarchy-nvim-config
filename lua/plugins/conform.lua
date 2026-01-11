return {
  "stevearc/conform.nvim",
  opts = {
    -- 1. Switch formatter to pg_format
    formatters_by_ft = {
      sql = { "pg_format" },
    },

    -- 2. Configure capitalization rules
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
    },
  },
}
