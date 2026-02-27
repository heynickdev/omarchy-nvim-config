-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- --- BASIC SETTINGS ---
vim.opt.nu = true -- Enables absolute line numbers on the left side of the buffer.
vim.opt.relativenumber = true -- Shows line numbers relative to the cursor position, useful for jump commands.
vim.g.lazyvim_animation = true -- Disables the UI animations that LazyVim adds by default.
vim.opt.wrap = false -- Disables line wrapping; long lines will extend off the edge of the screen.
vim.opt.scrolloff = 18 -- Enforces a minimum of 8 lines visible above and below the cursor when scrolling vertically.
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

-- --- NETRW & CLIPBOARD ---
vim.g.netrw_banner = 0 -- Hides the large, multiline help banner at the top of Vim's default Netrw file explorer.
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro" -- Applies strict buffer settings to Netrw windows: unmodifiable, numbers on, no buffer listing, no wrap, read-only.
-- vim.opt.clipboard = "unnamedplus" -- (Commented out) If active, this would force Neovim to use the system clipboard for all yank and paste operations.

-- --- KEYBOARD GLOBALS ---
-- vim.g.maplocalleader = ";" -- Sets the local leader key, typically used for filetype-specific plugin bindings, to the semicolon.
vim.g.autoformat = false -- A global flag read by plugins (like conform.nvim) to disable automatic code formatting on save by default.

-- --- TEMPL & HTML FILETYPE FIXES ---
vim.filetype.add({ -- Invokes the Neovim filetype API to define custom file extension mappings.
  extension = { -- Specifies that we are mapping based on the file's extension.
    templ = "templ", -- Tells Neovim to treat files ending in .templ as the "templ" filetype.
  }, -- Closes the extension table.
}) -- Closes the filetype.add function call.

-- Combine your templ logic into one clean autocmd
vim.api.nvim_create_autocmd("FileType", { -- Registers an autocommand that fires whenever a buffer's filetype is set.
  pattern = { "templ", "html" }, -- Ensures this logic only triggers for templ and html files, covering your Go and HTMX frontend work.
  callback = function() -- Defines the anonymous Lua function to run when the autocommand triggers.
    vim.bo.indentexpr = "nvim_treesitter#indent()" -- Sets the buffer-local option to use Treesitter's syntax tree for calculating accurate indentation.
    vim.opt_local.shiftwidth = 2 -- Forces the buffer-local shift width to 2 spaces.
    vim.opt_local.tabstop = 2 -- Forces the buffer-local tab stop to 2 spaces.
    vim.opt_local.softtabstop = 2 -- Forces the buffer-local soft tab stop to 2 spaces.
    vim.opt_local.expandtab = true -- Forces tabs to be expanded to spaces for these specific buffers.
    vim.opt_local.smartindent = true -- Ensures smart indentation is active locally.
  end, -- Ends the callback function body.
}) -- Closes the nvim_create_autocmd table and function call.

-- --- THE "SMART ENTER" FIX ---
-- This specifically fixes the <div>|</div> expansion issue
vim.keymap.set(
  "i",
  "<CR>",
  function() -- Creates a keymap for the Enter key (<CR>) in Insert mode ("i") that executes the following Lua function.
    local line = vim.api.nvim_get_current_line() -- Fetches the complete string of text on the line where the cursor currently resides.
    local col = vim.api.nvim_win_get_cursor(0)[2] -- Retrieves the current 0-indexed column position of the cursor in the active window.

    -- Check if cursor is between '>' and '<'
    local char_before = line:sub(col, col) -- Extracts the single character situated immediately before the cursor.
    local char_after = line:sub(col + 1, col + 1) -- Extracts the single character situated immediately after the cursor.

    if char_before == ">" and char_after == "<" then -- Evaluates if the cursor is perfectly sandwiched between a closing angle bracket and an opening one.
      -- Returns Enter, then Escapes to Normal mode, then 'O' to
      -- create a new indented line in between.
      return "<CR><Esc>O" -- Simulates a carriage return, drops to normal mode via Escape, and uses 'O' to open an indented line above.
    end -- Ends the conditional block.

    return "<CR>" -- If not between HTML-like tags, falls back to returning the standard Enter key behavior.
  end,
  { expr = true, replace_keycodes = true, desc = "Expand tags on Enter" }
) -- Configuration table: 'expr=true' executes the returned string, 'replace_keycodes' translates <CR>/<Esc> to actual keystrokes, and 'desc' labels the keymap.
