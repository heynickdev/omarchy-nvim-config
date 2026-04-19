return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        http = {
          lm_studio = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "lm_studio",
              env = {
                url = "http://100.123.68.115:1234",
                api_key = "lm-studio",
              },
            })
          end,
        },
      },
      strategies = {
        chat = {
          adapter = "lm_studio",
          -- Define variables like #repo
          variables = {
            ["repo"] = {
              callback = function()
                local handle = io.popen('repomix --stdout --style plain --include "**/*.{go,vue,js,py,sql,yaml,yml,c,cpp,cs,java,md}"')
                local result = handle:read("*a")
                handle:close()
                return result
              end,
              description = "Inject the entire codebase context using Repomix",
            },
          },
          -- Define slash commands like /repo
          slash_commands = {
            ["repo"] = {
              description = "Add repository context",
              callback = function(chat)
                -- This triggers the repomix command and adds it to the chat context
                local handle = io.popen('repomix --stdout --style plain --include "**/*.{go,vue,js,py,sql,yaml,yml,c,cpp,cs,java,md}"')
                local result = handle:read("*a")
                handle:close()
                
                chat:add_message({
                  role = "user",
                  content = "Here is my repository context:\n\n" .. result,
                })
              end,
            },
          },
          -- Enable "Doing stuff" (Agentic Tools)
          tools = {
            ["cmd"] = {
              callback = "interactions/chat/tools/builtin/run_command",
              description = "Run a shell command",
            },
            ["files"] = {
              callback = "interactions/chat/tools/builtin/create_file",
              description = "Create a new file",
            },
            ["editor"] = {
              callback = "interactions/chat/tools/builtin/insert_edit_into_file",
              description = "Edit an existing file",
            },
          },
        },
        inline = { adapter = "lm_studio" },
        agent = {
          adapter = "lm_studio",
          -- The Agent strategy uses the tools defined above to act autonomously
        },
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

    -- Keymaps
    vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true, desc = "AI Actions" })
    vim.keymap.set({ "n", "v" }, "<leader>to", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true, desc = "Toggle AI Chat" })
    vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true, desc = "Add to AI Chat" })
  end,
}
