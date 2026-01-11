return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- Ensure these parsers are always installed
    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, { "templ", "go", "html" })
    end

    opts.indent = {
      enable = true,
    }
  end,
}
