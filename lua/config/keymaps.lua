-- Keymaps are automatically loaded on the VeryLazy event, deferring execution to improve Neovim's initial launch speed.
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here to tailor the editor to specific project workflows.
--
-- This file is automatically loaded by lazyvim.config.init during the initialization sequence.

-- DO NOT USE `LazyVim.safe_keymap_set` IN YOUR OWN CONFIG!! -- (Warning from LazyVim maintainers regarding core overrides).
-- use `vim.keymap.set` instead -- (Standard advice for user-defined mappings to avoid conflicts).
local map = LazyVim.safe_keymap_set -- Creates a localized, shorter alias for the LazyVim-specific keymap function for cleaner syntax.

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true }) -- Maps 'j' in normal/visual modes to move down by visual lines (gj) if no count is provided, handling wrapped lines gracefully.
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true }) -- Mirrors the 'j' mapping logic for the Down arrow key.
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true }) -- Maps 'k' in normal/visual modes to move up by visual lines (gk) if no count is provided.
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true }) -- Mirrors the 'k' mapping logic for the Up arrow key.

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true }) -- Binds Ctrl+h to jump to the Neovim window split to the left.
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true }) -- Binds Ctrl+j to jump to the Neovim window split below.
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true }) -- Binds Ctrl+k to jump to the Neovim window split above.
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true }) -- Binds Ctrl+l to jump to the Neovim window split to the right.

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" }) -- Binds Ctrl+Up to increase the horizontal split height by 2 lines.
map("n", "<c-down>", "<cmd>resize -2<cr>", { desc = "decrease window height" }) -- Binds Ctrl+Down to decrease the horizontal split height by 2 lines.
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" }) -- Binds Ctrl+Left to shrink the vertical split width by 2 columns.
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" }) -- Binds Ctrl+Right to expand the vertical split width by 2 columns.

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" }) -- Binds Alt+j in normal mode to physically move the current line down, then re-indents it.
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" }) -- Binds Alt+k in normal mode to physically move the current line up, then re-indents it.
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" }) -- Binds Alt+j in insert mode to escape, move the line down, re-indent, and return to insert mode.
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" }) -- Binds Alt+k in insert mode to escape, move the line up, re-indent, and return to insert mode.

map("v", "<A-j>", ":<c-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "move down" }) -- Binds Alt+j in visual mode to move the entire selected block down and re-select it.
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" }) -- Binds Alt+k in visual mode to move the entire selected block up and re-select it.

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" }) -- Binds Shift+h to cycle to the previously opened buffer in the list.
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" }) -- Binds Shift+l to cycle to the next opened buffer in the list.
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" }) -- Provides an alternative mapping ([b) to cycle to the previous buffer.
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" }) -- Provides an alternative mapping (]b) to cycle to the next buffer.
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" }) -- Binds Space+bb to toggle instantly back to the last accessed buffer (alternate file).
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" }) -- Provides a faster alternative (Space+`) to toggle to the alternate file.
map("n", "<leader>bd", function() -- Begins a mapping for Space+bd to trigger buffer deletion.
  Snacks.bufdelete() -- Calls the Snacks API to delete the current buffer without closing the split window.
end, { desc = "Delete Buffer" }) -- Closes the function and adds the description metadata.
map("n", "<leader>bo", function() -- Begins a mapping for Space+bo to close everything else.
  Snacks.bufdelete.other() -- Calls the Snacks API to delete all open buffers EXCEPT the currently active one.
end, { desc = "Delete Other Buffers" }) -- Closes the function and adds the description metadata.
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" }) -- Binds Space+bD to violently delete the buffer, which also destroys the window split it resides in.

-- Clear search and stop snippet on escape
map(
  { "i", "n", "s" },
  "<esc>",
  function() -- Maps the Escape key across insert, normal, and select modes to a custom Lua function.
    vim.cmd("noh") -- Executes the 'nohlsearch' command to clear active search highlighting.
    LazyVim.cmp.actions.snippet_stop() -- Signals the completion engine (like LuaSnip/blink) to exit the current snippet expansion context.
    return "<esc>" -- Returns the actual Escape keycode so Neovim still performs its normal Escape behavior.
  end,
  { expr = true, desc = "Escape and Clear hlsearch" }
) -- Marks mapping as an expression (so the return value is executed) and adds a description.

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map( -- Opens the map function call.
  "n", -- specifies normal mode.
  "<leader>ur", -- binds to space+ur.
  "<cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>", -- clears search highlights, recalculates git/file diffs, and forces a complete screen redraw (ctrl+l).
  { desc = "Redraw / Clear hlsearch / Diff Update" } -- Configuration table for the mapping description.
) -- Closes the map function call.

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" }) -- Forces 'n' to always search in the forward direction, opening folds (zv) if necessary.
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" }) -- Applies the same forward-search logic to visual mode.
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" }) -- Applies the same forward-search logic to operator-pending mode.
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" }) -- Forces 'N' to always search in the backward direction, opening folds.
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" }) -- Applies the backward-search logic to visual mode.
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" }) -- Applies the backward-search logic to operator-pending mode.

-- Add undo break-points
map("i", ",", ",<c-g>u") -- Modifies the comma key in insert mode to add an undo checkpoint right after typing it.
map("i", ".", ".<c-g>u") -- Modifies the period key in insert mode to add an undo checkpoint right after typing it.
map("i", ";", ";<c-g>u") -- Modifies the semicolon key in insert mode to add an undo checkpoint right after typing it.

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" }) -- Binds Ctrl+s across multiple modes to write the file and immediately return to normal mode via escape.

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" }) -- Binds Space+Shift+K to execute the normal 'K' command (usually looks up documentation/man pages for the word under cursor).

-- better indenting
map("v", "<", "<gv") -- Modifies the '<' key in visual mode to shift text left AND immediately re-select the text block.
map("v", ">", ">gv") -- Modifies the '>' key in visual mode to shift text right AND immediately re-select the text block.

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" }) -- Complex macro: opens a line below, clears it, toggles comment status, and enters insert mode inside the comment marker.
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" }) -- Complex macro: opens a line above, clears it, toggles comment status, and enters insert mode inside the comment marker.

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" }) -- Binds Space+l to open the LazyVim plugin manager UI.

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" }) -- Binds Space+fn to open a completely new, empty, unnamed buffer.

-- location list
map("n", "<leader>xl", function() -- Binds Space+xl to execute an anonymous function for toggling the location list.
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen) -- Safely attempts to check if the location list is open; if true, closes it (`lclose`), otherwise opens it (`lopen`).
  if not success and err then -- Checks if the `pcall` caught an error during execution.
    vim.notify(err, vim.log.levels.ERROR) -- Pushes the error message to the Neovim notification system.
  end -- Closes the error check block.
end, { desc = "Location List" }) -- Closes the function and sets the keymap description.

-- quickfix list
map(
  "n",
  "<leader>xq",
  function() -- Binds Space+xq to execute an anonymous function for toggling the global quickfix list.
    local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen) -- Safely attempts to check if the quickfix window is active; closes (`cclose`) if open, opens (`copen`) if closed.
    if not success and err then -- Evaluates if the `pcall` failed.
      vim.notify(err, vim.log.levels.ERROR) -- Displays the resulting error via `vim.notify`.
    end -- Ends the conditional error handling.
  end,
  { desc = "Quickfix List" }
) -- Closes the anonymous function and applies the description.

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" }) -- Binds [q to directly invoke the command jumping to the previous item in the quickfix list.
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" }) -- Binds ]q to directly invoke the command jumping to the next item in the quickfix list.

-- formatting
map({ "n", "v" }, "<leader>cf", function() -- Binds Space+cf in normal and visual modes to trigger code formatting.
  LazyVim.format({ force = true }) -- Calls the LazyVim format API, forcing execution even if auto-format on save is disabled.
end, { desc = "Format" }) -- Closes the format function mapping.

-- diagnostic
local diagnostic_goto = function(next, severity) -- Defines a local helper function that returns a customized jump function based on direction and severity.
  return function() -- Returns the actual executable closure to be mapped to a key.
    vim.diagnostic.jump({ -- Calls the Neovim 0.10+ API to jump between LSP diagnostics.
      count = (next and 1 or -1) * vim.v.count1, -- Determines jump direction (forward for 1, backward for -1) multiplied by any numerical count provided by the user.
      severity = severity and vim.diagnostic.severity[severity] or nil, -- Filters jumps by ERROR or WARN if a severity was passed, otherwise jumps to any diagnostic.
      float = true, -- Ensures the floating window containing the diagnostic message opens immediately upon jumping.
    }) -- Closes the diagnostic.jump configuration table.
  end -- Ends the returned closure.
end -- Ends the factory function definition.
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" }) -- Binds Space+cd to manually open the floating window for the diagnostic on the current line.
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" }) -- Binds ]d to jump to the next diagnostic of any severity.
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" }) -- Binds [d to jump to the previous diagnostic of any severity.
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" }) -- Binds ]e to jump strictly to the next LSP error.
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" }) -- Binds [e to jump strictly to the previous LSP error.
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" }) -- Binds ]w to jump strictly to the next LSP warning.
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" }) -- Binds [w to jump strictly to the previous LSP warning.

-- stylua: ignore start -- Instructs the StyLua formatter to skip formatting the following lines to preserve exact vertical alignment.

-- toggle options
LazyVim.format.snacks_toggle():map("<leader>uf") -- Binds Space+uf to a Snacks toggle that enables/disables automatic formatting on save.
LazyVim.format.snacks_toggle(true):map("<leader>uF") -- Binds Space+uF to a Snacks toggle for formatting, specifically targeting buffer-local vs global overrides.
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us") -- Binds Space+us to toggle Neovim's built-in spell checker.
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw") -- Binds Space+uw to toggle visual line wrapping.
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL") -- Binds Space+uL to toggle relative line numbers in the gutter.
Snacks.toggle.diagnostics():map("<leader>ud") -- Binds Space+ud to toggle the visibility of virtual text and signs for LSP diagnostics.
Snacks.toggle.line_number():map("<leader>ul") -- Binds Space+ul to completely hide or show the line number column.
Snacks.toggle
  .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
  :map("<leader>uc") -- Binds Space+uc to toggle markdown/syntax concealment (hiding formatting characters like **).
Snacks.toggle
  .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
  :map("<leader>uA") -- Binds Space+uA to toggle the visibility of the buffer/tab bar at the top of the screen.
Snacks.toggle.treesitter():map("<leader>uT") -- Binds Space+uT to toggle Treesitter-based syntax highlighting on and off.
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub") -- Binds Space+ub to switch between the 'light' and 'dark' variations of your active colorscheme.
Snacks.toggle.dim():map("<leader>uD") -- Binds Space+uD to toggle an active-window dimming effect.
Snacks.toggle.animate():map("<leader>ua") -- Binds Space+ua to toggle UI animations globally (scrolling, window resizing).
Snacks.toggle.indent():map("<leader>ug") -- Binds Space+ug to toggle the visibility of vertical indentation guide lines.
Snacks.toggle.scroll():map("<leader>uS") -- Binds Space+uS to toggle smooth scrolling behavior.
Snacks.toggle.profiler():map("<leader>dpp") -- Binds Space+dpp to toggle the Snacks performance profiler for debugging slow Neovim setups.
Snacks.toggle.profiler_highlights():map("<leader>dph") -- Binds Space+dph to toggle highlight groups specific to the profiler UI.

if vim.lsp.inlay_hint then -- Checks if the current Neovim binary actually supports LSP inlay hints (introduced in v0.10).
  Snacks.toggle.inlay_hints():map("<leader>uh") -- If supported, binds Space+uh to toggle inline variable/type hints provided by the language server.
end -- Ends the inlay hint capability check.
-- lazygit
if vim.fn.executable("lazygit") == 1 then -- Checks the system path to ensure the 'lazygit' terminal UI is installed before mapping keys.
  map("n", "<leader>gg", function()
    Snacks.lazygit({ cwd = LazyVim.root.git() })
  end, { desc = "Lazygit (Root Dir)" }) -- Binds Space+gg to open Lazygit, anchoring the working directory to the project's root .git folder.
  map("n", "<leader>gG", function()
    Snacks.lazygit()
  end, { desc = "Lazygit (cwd)" }) -- Binds Space+gG to open Lazygit using the exact current working directory of the buffer.
end -- Ends the lazygit installation check.

map("n", "<leader>gL", function()
  Snacks.picker.git_log()
end, { desc = "Git Log (cwd)" }) -- Binds Space+gL to open a Snacks picker UI displaying the commit history for the current directory.
map("n", "<leader>gb", function()
  Snacks.picker.git_log_line()
end, { desc = "Git Blame Line" }) -- Binds Space+gb to open a picker showing the git commit history specifically for the line under the cursor.
map("n", "<leader>gf", function()
  Snacks.picker.git_log_file()
end, { desc = "Git Current File History" }) -- Binds Space+gf to open a picker showing the entire commit history for the currently active file.
map("n", "<leader>gl", function()
  Snacks.picker.git_log({ cwd = LazyVim.root.git() })
end, { desc = "Git Log" }) -- Binds Space+gl to show project-wide commit history anchored at the .git root.
map({ "n", "x" }, "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git Browse (open)" }) -- Binds Space+gB to open the current file/line in the default web browser (GitHub/GitLab).
map(
  { "n", "x" },
  "<leader>gY",
  function() -- Binds Space+gY to copy the web link of the current file/line to the clipboard.
    Snacks.gitbrowse({
      open = function(url)
        vim.fn.setreg("+", url)
      end,
      notify = false,
    }) -- Modifies the browse behavior: instead of opening a browser, sets the '+' register (system clipboard) to the URL quietly.
  end,
  { desc = "Git Browse (copy)" }
) -- Closes the URL copy function.

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" }) -- Binds Space+qq to cleanly exit all open windows and quit Neovim.

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" }) -- Binds Space+ui to reveal the specific syntax highlight groups active at the exact cursor position.
map("n", "<leader>uI", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input("I")
end, { desc = "Inspect Tree" }) -- Binds Space+uI to open a side window displaying the parsed Treesitter Abstract Syntax Tree for debugging.

-- LazyVim Changelog
map("n", "<leader>L", function()
  LazyVim.news.changelog()
end, { desc = "LazyVim Changelog" }) -- Binds Space+L to fetch and display recent release notes for the LazyVim distribution.

-- floating terminal
map("n", "<leader>fT", function()
  Snacks.terminal()
end, { desc = "Terminal (cwd)" }) -- Binds Space+fT to open a floating terminal window localized to the current directory.
map("n", "<leader>ft", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" }) -- Binds Space+ft to open a floating terminal anchored to the project root.
-- Switch from terminal to normal mode with Esc
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Enter normal mode" }) -- Maps Escape inside the built-in terminal to trigger the complex keycode required to exit terminal-insert mode.
map({ "n", "t" }, "<c-/>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" }) -- Binds Ctrl+/ to quickly toggle the floating root terminal from normal or terminal mode.
map({ "n", "t" }, "<c-_>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "which_key_ignore" }) -- Secondary binding for Ctrl+/ (recognized as Ctrl+_ by some terminal emulators) to toggle the terminal.

-- windows
map("n", "<leader>-", "<C-W>s<cmd>Ex<cr>", { desc = "Split Window Below", remap = true }) -- Binds Space+- to slice the current window horizontally, placing the new split below.
map("n", "<leader>|", "<C-W>v<cmd>Ex<cr>", { desc = "Split Window Right", remap = true }) -- Binds Space+| to slice the current window vertically, placing the new split to the right.
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true }) -- Binds Space+wd to close the currently focused window split.
Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ") -- Sets up both Space+wm and Space+uZ to maximize the current window split, hiding the others until toggled again.
Snacks.toggle.zen():map("<leader>uz") -- Binds Space+uz to enter a distraction-free "Zen Mode" utilizing the Snacks API.

-- Select all
map("n", "<leader>a", "ggVG", { desc = "select all" }) -- Binds Space+a to jump to the top (gg), enter visual line mode (V), and jump to the bottom (G), highlighting the whole file.
-- map("n", "<leader>aa", 'ggVG\"+yG', { desc = "Select All and copy" }) -- (Commented out) Legacy mapping attempt to select and copy.
vim.keymap.set("n", "<leader>aa", 'mzggVG"+y`z:delmarks z<CR>', { desc = "Select all, copy, and return cursor" }) -- Binds Space+aa to set a mark (z), highlight all, copy to clipboard ("+y), return to mark (`z), and clean up the mark.
map("n", "<leader>pv", vim.cmd.Ex) -- Binds Space+pv to open Neovim's default Netrw directory explorer in the current window.

-- Yanking (copying) TO the system clipboard
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to System Clipboard", noremap = true, silent = true }) -- Binds Space+y in normal mode to initiate a copy operation routed to the OS clipboard.
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to System Clipboard", noremap = true, silent = true }) -- Binds Space+y in visual mode to copy the active selection directly to the OS clipboard.
vim.keymap.set("n", "<leader>yy", '"+Y', { desc = "Yank Line to System Clipboard", noremap = true, silent = true }) -- Binds Space+yy to copy the entire current line to the OS clipboard.

-- FULL CORRECTED COMMAND SNIPPET
vim.keymap.set("n", "<leader>ap", function() -- Binds Space+ap to replace the entire buffer with clipboard contents.
  -- The 't' means execute the keys as if typed (normal mode commands) -- (User-provided comment)
  vim.api.nvim_feedkeys('ggVG"+p', "t", true) -- Programmatically simulates typing: go to top, select all, and paste from the system clipboard ("+p).
end, { -- Opens the options table.
  desc = "Replace everything with clipboard", -- Describes the function for WhichKey.
  noremap = true, -- Ensures these keys trigger built-in actions, ignoring other user mappings.
  silent = true, -- Suppresses command-line output during execution.
}) -- Closes the setup table.

-- FULL CORRECTED COMMAND SNIPPET for Black Hole Delete
vim.keymap.set("n", "<leader>AD", function() -- Binds Space+AD to delete the entire file without overwriting registers.
  -- Deletes entire file using the black hole register -- (User-provided comment)
  vim.api.nvim_feedkeys('ggVG"_d', "t", true) -- Simulates typing: go to top, select all, and delete into the void register ("_d) so it doesn't pollute your clipboard.
end, { -- Opens the options table.
  desc = "Black hole remove everything", -- Describes the action.
  noremap = true, -- Prevents recursive mapping evaluation.
  silent = true, -- Prevents visual output noise.
}) -- Closes the setup table.
-- Function to toggle LSP clients for the current buffer
local function toggle_lsp() -- Defines a custom function to handle restarting memory-heavy language servers.
  local clients = vim.lsp.get_active_clients({ bufnr = 0 }) -- Queries the Neovim LSP API to get a list of servers attached to the current buffer.
  if #clients > 0 then -- Checks if the array of active clients contains at least one server.
    -- LSP is active, so stop it -- (User-provided comment)
    print("Stopping LSP clients for current buffer...") -- Outputs a status message to the command line.
    vim.lsp.stop_client(clients) -- Issues the command to cleanly shut down the attached server processes.
  else -- Executes if no clients are found.
    -- LSP is inactive, so re-trigger FileType autocommands -- (User-provided comment)
    -- This will make lspconfig (or your setup) attach the clients again -- (User-provided comment)
    print("Starting LSP for current buffer...") -- Outputs a status message.
    vim.cmd("doautocmd <nomodeline> FileType") -- Tricks Neovim into re-evaluating the buffer's filetype, which forces lspconfig to boot up the relevant server (e.g., OmniSharp or jdtls).
  end -- Ends the conditional logic.
end -- Ends the toggle_lsp function.
vim.keymap.set("n", "<leader>tt", toggle_lsp, { desc = "Toggle LSP (Start/Stop)" }) -- Binds Space+tt to execute the custom toggle_lsp logic.

-- FULL EDITED CODE SNIPPET (Lua)
-- Add this to your configuration structure (e.g., in a spec that runs after 'nvim-lspconfig') -- (User-provided context).

--Disable by default
-- vim.lsp.inlay_hint.enable(false) -- (Commented out) Native command to ensure hints start disabled.
--
vim.keymap.set("n", "<leader>ti", function() -- Binds Space+ti to toggle native LSP inlay hints.
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) -- Queries the current state of inlay hints and flips the boolean to enable or disable them dynamically.
end, { desc = "Toggle Inlay Hints" }) -- Closes the function and sets the description.
