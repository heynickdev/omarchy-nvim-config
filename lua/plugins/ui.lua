return {
  -- 1. Disable Bufferline (using standard tabs/buffers instead)
  { "akinsho/bufferline.nvim", enabled = false },

  -- 2. Disable Dashboard (optional, user preference)
  { "nvimdev/dashboard-nvim", enabled = false },

  -- 3. Neo-tree: Add line numbers and relative numbers to the tree window
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              vim.opt_local.number = true
              vim.opt_local.relativenumber = true
            end,
          },
        },
      },
    },
  },

  -- 4. Undotree: Visual undo history
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
    },
  },

  -- 5. Colorizer: Highlight hex/rgb colors in code
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
      filetypes = { "*" },
    },
    config = function(_, opts)
      require("colorizer").setup(opts.filetypes, opts)
    end,
  },

  -- 6. Transparency Configuration
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      require("transparent").setup({
        extra_groups = {
          "NormalFloat",
          "NvimTreeNormal",
          "NeoTreeNormal",
          "NeoTreeNormalNC",
          "TelescopeNormal",
          "TelescopeBorder",
          "WhichKeyFloat",
          "FloatBorder",
          "Pmenu",
          "Terminal",
          "EndOfBuffer",
          "FoldColumn",
          "Folded",
          "SignColumn",
          "TelescopePromptBorder",
          "TelescopePromptTitle",
          "NeoTreeVertSplit",
          "NeoTreeWinSeparator",
          "NeoTreeEndOfBuffer",
          "NvimTreeVertSplit",
          "NvimTreeEndOfBuffer",
          "NotifyINFOBody",
          "NotifyERRORBody",
          "NotifyWARNBody",
          "NotifyTRACEBody",
          "NotifyDEBUGBody",
          "NotifyINFOTitle",
          "NotifyERRORTitle",
          "NotifyWARNTitle",
          "NotifyTRACETitle",
          "NotifyDEBUGTitle",
          "NotifyINFOBorder",
          "NotifyERRORBorder",
          "NotifyWARNBorder",
          "NotifyTRACEBorder",
          "NotifyDEBUGBorder",
        },
      })
      vim.cmd("TransparentEnable")
    end,
  },
}
