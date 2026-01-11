return {
  "windwp/nvim-autopairs",
  opts = {
    check_ts = true, -- use treesitter to check for a pair
    render_creator = true,
  },
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)

    -- Force autopairs to handle the Enter key specifically for tags
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
