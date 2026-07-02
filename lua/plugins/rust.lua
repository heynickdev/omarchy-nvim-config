-- lua/plugins/rust.lua
return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Pin to latest stable
    lazy = false, -- Required for proper LSP initialization
    config = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            -- Your existing LSP keymaps here
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
            },
          },
        },
      }
    end,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = { cmp = { enabled = true } },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = { "rouge8/neotest-rust" },
    opts = {
      adapters = {
        ["neotest-rust"] = {},
      },
    },
  },
}
