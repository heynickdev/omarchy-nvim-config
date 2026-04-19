-- Autocommands are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- --- TEMPL & HTML FILETYPE FIXES ---
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "templ", "html" },
  callback = function()
    vim.bo.indentexpr = "nvim_treesitter#indent()"
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.smartindent = true

    if vim.bo.filetype == "templ" then
      vim.cmd("runtime! indent/html.vim")

      _G.TemplIndent = function()
        local lnum = vim.v.lnum
        local prev_lnum = vim.fn.prevnonblank(lnum - 1)
        local prev_line = vim.fn.getline(prev_lnum)

        if prev_line:match("{$") then
          return vim.fn.indent(prev_lnum) + vim.fn.shiftwidth()
        end

        local cur_line = vim.fn.getline(lnum)
        if cur_line:match("^%s*}$") then
          return vim.fn.indent(prev_lnum) - vim.fn.shiftwidth()
        end

        return vim.fn.HtmlIndent()
      end

      vim.opt_local.indentexpr = "v:lua.TemplIndent()"
      vim.opt_local.smartindent = false
    end
  end,
})
