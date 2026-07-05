return {
  {
    "AvengeMedia/base46",
    lazy = false,
    priority = 1000,
    opts = {
      set_background = true,
    },
    config = function(_, opts)
      require("base46").setup(opts)
      vim.cmd.colorscheme("base46-matugen")
    end,
  },
}
