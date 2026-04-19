-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- --- BASIC SETTINGS ---
vim.opt.nu = true -- Enables absolute line numbers on the left side of the buffer.
vim.opt.relativenumber = true -- Shows line numbers relative to the cursor position, useful for jump commands.
vim.g.lazyvim_animation = true -- Disables the UI animations that LazyVim adds by default.
vim.opt.wrap = false -- Disables line wrapping; long lines will extend off the edge of the screen.
vim.opt.scrolloff = 18 -- Enforces a minimum of 8 lines visible above and below the cursor when scrolling vertically.
vim.opt.sidescrolloff = 3
vim.opt.signcolumn = "yes" -- Always displays the gutter column on the left (used for git signs, linting icons) to stop text from shifting.
vim.opt.colorcolumn = "150" -- Renders a vertical highlight at the 80th character mark to help visualize line length limits.
vim.opt.updatetime = 50 -- Lowers the delay (in milliseconds) before Vim triggers CursorHold events, making the UI and plugins highly responsive.
vim.opt.termguicolors = true -- Enables 24-bit RGB true colors, which is vital for rich themes in modern terminals like Kitty.

-- --- INDENTATION (2 SPACES) ---
vim.opt.tabstop = 2 -- Defines that a <Tab> character in the file is rendered as 2 spaces wide.
vim.opt.softtabstop = 2 -- Defines that pressing the Tab key in Insert mode inserts 2 spaces.
vim.opt.shiftwidth = 2 -- Defines the number of spaces used for indentation operations (like >> or <<).
vim.opt.expandtab = true -- Automatically converts <Tab> characters into actual space characters when typing.
vim.opt.autoindent = true -- Copies the indentation level from the current line when pressing Enter to start a new line.
vim.opt.smartindent = true -- Automatically adds extra indentation after opening braces and in other syntax-specific scenarios.

-- --- FILESYSTEM & SEARCH ---
vim.opt.swapfile = false -- Prevents Vim from creating .swp files (used for crash recovery), reducing filesystem clutter.
vim.opt.backup = false -- Prevents Vim from creating a backup file before saving changes to a file.
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Sets the exact directory path where persistent undo history will be stored.
vim.opt.undofile = true -- Enables persistent undo, letting you undo changes across different editor sessions.
vim.opt.hlsearch = false -- Turns off the persistent background highlighting of all search terms once the search is executed.
vim.opt.incsearch = true -- Highlights the first matching search result incrementally as you are still typing the pattern.
vim.opt.isfname:append("@-@") -- Appends the '@' symbol to valid filename characters, making it easier to open paths like npm scoped packages (e.g., @scope/pkg).

-- --- TEMPL & HTML FILETYPE ---
vim.filetype.add({
  extension = {
    templ = "templ",
  },
})

-- --- NETRW & CLIPBOARD ---
vim.g.netrw_banner = 0 -- Hides the large, multiline help banner at the top of Vim's default Netrw file explorer.
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro" -- Applies strict buffer settings to Netrw windows: unmodifiable, numbers on, no buffer listing, no wrap, read-only.
vim.opt.clipboard = "unnamedplus" -- Relies purely on Neovim's native Wayland detection to bridge the system clipboard without complex overrides.

-- --- KEYBOARD GLOBALS ---
-- vim.g.maplocalleader = ";" -- Sets the local leader key, typically used for filetype-specific plugin bindings, to the semicolon.
vim.g.autoformat = false -- A global flag read by plugins (like conform.nvim) to disable automatic code formatting on save by default.

vim.opt.mouse = ""
