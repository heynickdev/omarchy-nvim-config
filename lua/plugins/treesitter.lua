return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      -- Added "svelte" to the existing list
      vim.list_extend(opts.ensure_installed, {
        "svelte",
        "templ",
        "go",
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
