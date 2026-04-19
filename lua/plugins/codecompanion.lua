return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: for autocomplete integration
    "nvim-telescope/telescope.nvim", -- Optional: for saving/loading chats
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        lm_studio = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "http://100.123.68.115:1234",
              api_key = "lm-studio",
            },
          })
        end,
      },
      strategies = {
        chat = { adapter = "lm_studio" },
        inline = { adapter = "lm_studio" },
        agent = { adapter = "lm_studio" },
      },
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt ",
          provider = "telescope",
        },
      },
    })

    vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true, desc = "AI Actions" })
    vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true, desc = "Toggle AI Chat" })
    vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true, desc = "Add to AI Chat" })
  end,
}
