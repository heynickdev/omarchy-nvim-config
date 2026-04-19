return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, {
        "svelte",
        "templ",
        "go",
        "gomod",
        "html",
        "htmldjango",
        "css",
        "javascript",
      })
    end

    opts.indent = {
      enable = true,
    }
  end,
}
