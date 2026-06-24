-- Options are automatically loaded before lazy.nvim startup.

vim.opt.number = true
vim.opt.relativenumber = true
vim.g.lazyvim_animation = true

vim.opt.wrap = false
vim.opt.scrolloff = 18
vim.opt.sidescrolloff = 3
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "150"

vim.opt.updatetime = 50
vim.opt.termguicolors = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false

local undo_dir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undo_dir, "p")
vim.opt.undodir = undo_dir
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.filetype.add({
  extension = {
    templ = "templ",
  },
})

-- Netrw
-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_hide = 1
vim.g.netrw_list_hide = [[^\.$,^\.\.$,^\./$,^\.\./$]]
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"

vim.opt.clipboard = "unnamedplus"

vim.g.autoformat = false
