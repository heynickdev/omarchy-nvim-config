-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- --- BASIC SETTINGS ---
vim.opt.nu = true
vim.opt.relativenumber = true
vim.g.lazyvim_animation = false
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.opt.updatetime = 50
vim.opt.termguicolors = true

-- --- INDENTATION (2 SPACES) ---
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- --- FILESYSTEM & SEARCH ---
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")

-- --- NETRW & CLIPBOARD ---
vim.g.netrw_banner = 0
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
vim.opt.clipboard = "unnamedplus"

-- --- KEYBOARD GLOBALS ---
vim.g.maplocalleader = ";"
vim.g.autoformat = false -- Global autoformat toggle

-- --- TEMPL & HTML FILETYPE FIXES ---
vim.filetype.add({
  extension = {
    templ = "templ",
  },
})

-- Combine your templ logic into one clean autocmd
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "templ", "html" },
  callback = function()
    vim.bo.indentexpr = "nvim_treesitter#indent()"
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.smartindent = true
  end,
})

-- --- THE "SMART ENTER" FIX ---
-- This specifically fixes the <div>|</div> expansion issue
vim.keymap.set("i", "<CR>", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  -- Check if cursor is between '>' and '<'
  local char_before = line:sub(col, col)
  local char_after = line:sub(col + 1, col + 1)

  if char_before == ">" and char_after == "<" then
    -- Returns Enter, then Escapes to Normal mode, then 'O' to
    -- create a new indented line in between.
    return "<CR><Esc>O"
  end

  return "<CR>"
end, { expr = true, replace_keycodes = true, desc = "Expand tags on Enter" })
