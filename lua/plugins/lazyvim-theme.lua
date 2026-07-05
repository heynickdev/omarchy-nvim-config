return {
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = function()
        local theme_file = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
        local ok, spec = pcall(dofile, theme_file)

        if not ok then
          vim.notify(spec, vim.log.levels.ERROR, { title = "dankcolors" })
          return
        end

        if spec and spec[1] and spec[1].config then
          spec[1].config()
          vim.g.colors_name = "dankcolors"
        end
      end
    end,
  },
}
