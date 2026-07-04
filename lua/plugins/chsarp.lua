return {
  -- The Roslyn Language Server (Provides VS/Rider level intelligence)
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {
      -- "auto" leaves filewatching as default, "roslyn" makes roslyn do it.
      filewatching = "auto",
    },
  },

  -- The workflow plugin (Handles running, building, testing, and debugging)
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      -- Assumes you are using telescope, fzf-lua, or snacks for UI picking.
      "nvim-telescope/telescope.nvim", 
    },
    ft = { "cs", "fsharp", "razor" },
    config = function()
      local dotnet = require("easy-dotnet")

      dotnet.setup({
        -- Path to the netcoredbg executable installed via pacman
        test_runner = {
          viewmode = "split",
        },
        terminal = function(path, action, args)
          -- Customize how the terminal opens for runs. 
          -- You can change this to use toggleterm or a floating window.
          vim.cmd("vsplit")
          vim.cmd("term " .. action .. " " .. args)
        end,
      })

      -- Keymaps for essential C# workflows
      vim.keymap.set("n", "<leader>dr", function()
        dotnet.run_project()
      end, { desc = "Run .NET Project" })

      vim.keymap.set("n", "<leader>dt", function()
        dotnet.test_runner()
      end, { desc = "Open .NET Test Runner" })

      vim.keymap.set("n", "<leader>db", function()
        dotnet.build_project()
      end, { desc = "Build .NET Project" })

      vim.keymap.set("n", "<leader>ds", function()
        dotnet.secrets()
      end, { desc = "Manage .NET User Secrets" })
    end,
  }
}
