return {
  -- 1. Disable mini.pairs (LazyVim default)
  { "nvim-mini/mini.pairs", enabled = false },

  -- 2. Install nvim-autopairs & Integrate with CMP
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    opts = {
      check_ts = true, -- Check treesitter
      map_c_h = true, -- Map the <C-h> key to delete a pair
      map_c_w = true, -- map <c-w> to delete a pair if possible
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)

      -- Remove the default rule for < to stop the conflict/glitch
      npairs.remove_rule("<")

      -- Connect Autopairs to CMP
      local status, cmp = pcall(require, "cmp")
      if status then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- 3. Ensure autotag is still running for closing HTML tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    },
  },
}
