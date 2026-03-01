return {
  {
    "ThePrimeagen/99",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local _99 = require("99")
      local cwd = vim.uv.cwd()
      local basename = vim.fs.basename(cwd)

      _99.setup({
        -- Uncomment the following line to use the Claude provider installed via pnpm
        -- provider = _99.Providers.ClaudeCodeProvider, 
        logger = {
          level = _99.DEBUG,
          path = "/tmp/" .. basename .. ".99.debug",
          print_on_error = true,
        },
        tmp_dir = "./tmp",
        completion = {
          -- Set to "blink" if you have migrated to blink.cmp in newer LazyVim versions
          source = "cmp", 
          custom_rules = {},
          files = {},
        },
        md_files = {
          "AGENT.md",
        },
      })

      -- Core keymaps
      -- The visual remap is restricted to visual mode to ensure it captures the correct selection state
      vim.keymap.set("v", "<leader>9v", function() _99.visual() end, { desc = "99: Send Visual Selection" })
      vim.keymap.set("n", "<leader>9x", function() _99.stop_all_requests() end, { desc = "99: Stop In-Flight Requests" })
      vim.keymap.set("n", "<leader>9s", function() _99.search() end, { desc = "99: Search Project" })

      -- Extension keymaps for Telescope
      vim.keymap.set("n", "<leader>9m", function() require("99.extensions.telescope").select_model() end, { desc = "99: Select Model" })
      vim.keymap.set("n", "<leader>9p", function() require("99.extensions.telescope").select_provider() end, { desc = "99: Select Provider" })
    end,
  }
}
