-- FULL EDITED OPTIONS.LUA
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = true
vim.g.lazyvim_animation = false

vim.opt.nu = true
vim.opt.relativenumber = true

-- --- START FIX FOR INDENTATION CONFLICT ---
-- Standardize all web dev/JS/TS indentation to 2 spaces
vim.opt.tabstop = 2
vim.opt.softtabstop = 2   -- CHANGED FROM 4 to 2 (ensures Tab key moves 2 spaces)
vim.opt.shiftwidth = 2    -- CHANGED FROM 4 to 2 (ensures Enter/auto-indent is 2 spaces)
vim.opt.expandtab = true
-- --- END FIX FOR INDENTATION CONFLICT ---

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- hide netrw banner
vim.g.netrw_banner = 0

-- clipboard
vim.opt.clipboard = "unnamedplus" -- Corrected standard Neovim clipboard option for system clipboard

-- netrw relative number
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
vim.opt_local.number = true
vim.opt_local.relativenumber = true

-- auto format
vim.g.autoformat = false

-- local leader
vim.g.maplocalleader = ';'
