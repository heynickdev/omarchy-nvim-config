-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  -- Override the nvim-lspconfig plugin settings
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        angularls = {
          enabled = false,
        },
        gopls = {}

        -- If you want to configure tsserver to potentially resolve the SIGTERM error
        -- (though that error is often harmless/environmental), you could add an entry
        -- like this to set a memory limit for the Node process:
        -- tsserver = {
        --   settings = {
        --     tsserver = {
        --       maxTsServerMemory = 4096, -- 4GB, adjust as needed
        --     },
        --   },
        -- },
      },
      -- You can also add setup logic here if you need to integrate
      -- with external tools, like for your Next.js development.
    },
  },
}

