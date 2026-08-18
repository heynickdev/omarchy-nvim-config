-- LazyVim provides the standard editor mappings. Keep only local overrides here.
local map = vim.keymap.set

-- Move LazyVim's profiler mappings away from the reclaimed <leader>d namespace.
Snacks.toggle.profiler():map("<leader>zpp")
Snacks.toggle.profiler_highlights():map("<leader>zph")

-- Terminal navigation and a single Ctrl+/ terminal tied to its original cwd.
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Enter Normal Mode" })

local ctrl_slash_terminal_cwd

local function focus_terminal()
  vim.schedule(function()
    if vim.bo.buftype ~= "terminal" then
      return
    end

    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
    vim.cmd.startinsert()
  end)
end

local function toggle_terminal()
  if ctrl_slash_terminal_cwd then
    local terminal = Snacks.terminal.get(nil, {
      cwd = ctrl_slash_terminal_cwd,
      count = 1,
      create = false,
    })

    if terminal and terminal:buf_valid() then
      Snacks.terminal.focus(nil, { cwd = ctrl_slash_terminal_cwd, count = 1 })
      focus_terminal()
      return
    end
  end

  ctrl_slash_terminal_cwd = vim.fn.getcwd(0)
  Snacks.terminal.focus(nil, { cwd = ctrl_slash_terminal_cwd, count = 1 })
  focus_terminal()
end

local function toggle_terminal_from_terminal_mode()
  local normal_mode = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
  vim.api.nvim_feedkeys(normal_mode, "n", false)
  vim.schedule(toggle_terminal)
end

map("n", "<C-/>", toggle_terminal, { desc = "Terminal (cwd)" })
map("n", "<C-_>", toggle_terminal, { desc = "which_key_ignore" })
map("t", "<C-/>", toggle_terminal_from_terminal_mode, { desc = "Terminal (cwd)" })
map("t", "<C-_>", toggle_terminal_from_terminal_mode, { desc = "which_key_ignore" })

-- Open Netrw in new splits instead of an empty window.
map("n", "<leader>-", "<C-W>s<cmd>Explore<cr>", { desc = "Split Below with Netrw", remap = true })
map("n", "<leader>|", "<C-W>v<cmd>Explore<cr>", { desc = "Split Right with Netrw", remap = true })
map("n", "<leader>wv", "<cmd>vsplit<cr><cmd>Explore<cr>", { desc = "Split Right with Netrw" })

-- Buffer-wide actions. Lowercase uses the system clipboard; uppercase keeps
-- Neovim's unnamed register local. `clipboard` remains empty in options.lua.
local function get_buffer_lines()
  return vim.api.nvim_buf_get_lines(0, 0, -1, false)
end

local function set_buffer_lines(lines)
  if not lines or #lines == 0 then
    lines = { "" }
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
end

local function set_linewise_register(register, lines)
  vim.fn.setreg(register, lines, "V")
end

local yank_highlight_namespace = vim.api.nvim_create_namespace("SystemClipboardYankHighlight")

local function highlight_yanked_lines(first_line, last_line, first_column, last_column)
  local buffer = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(buffer, yank_highlight_namespace, 0, -1)

  for line = first_line, last_line do
    local start_column = line == first_line and (first_column or 0) or 0
    local end_column = line == last_line and (last_column or -1) or -1
    vim.api.nvim_buf_add_highlight(buffer, yank_highlight_namespace, "IncSearch", line - 1, start_column, end_column)
  end

  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(buffer) then
      vim.api.nvim_buf_clear_namespace(buffer, yank_highlight_namespace, 0, -1)
    end
  end, 200)
end

local function replace_buffer_from_register(register)
  local lines = vim.fn.getreg(register, 1, true)
  set_buffer_lines(type(lines) == "table" and lines or vim.split(lines or "", "\n", { plain = true }))
end

local function copy_buffer_locally()
  local lines = get_buffer_lines()
  set_linewise_register("0", lines)
  set_linewise_register('"', lines)
end

local function delete_buffer_locally()
  local lines = get_buffer_lines()
  set_linewise_register("1", lines)
  set_linewise_register('"', lines)
  set_buffer_lines({ "" })
end

map("n", "<leader>av", "ggVG", { desc = "Select All" })
map("n", "<leader>ac", function()
  set_linewise_register("+", get_buffer_lines())
  highlight_yanked_lines(1, vim.api.nvim_buf_line_count(0))
end, { desc = "Copy All to System Clipboard" })
map("n", "<leader>ap", function()
  replace_buffer_from_register("+")
end, { desc = "Replace All from System Clipboard" })
map("n", "<leader>aC", copy_buffer_locally, { desc = "Copy All Locally" })
map("n", "<leader>aP", function()
  replace_buffer_from_register('"')
end, { desc = "Replace All from Local Register" })
map("n", "<leader>ad", delete_buffer_locally, { desc = "Delete All Locally" })
map("n", "<leader>aD", function()
  set_buffer_lines({ "" })
end, { desc = "Delete All into Nothing" })

-- Reclaim <leader>d from LazyVim/DAP/DB plugins. DAP lives under <leader>z.
local function clear_leader_prefix(prefix)
  local leader = vim.g.mapleader or "\\"
  local encoded_prefix = vim.api.nvim_replace_termcodes(leader .. prefix, true, true, true)

  for _, mode in ipairs({ "n", "x", "o" }) do
    for _, mapping in ipairs(vim.api.nvim_get_keymap(mode)) do
      local lhs = vim.api.nvim_replace_termcodes(mapping.lhs, true, true, true)
      if lhs:sub(1, #encoded_prefix) == encoded_prefix then
        pcall(vim.keymap.del, mode, mapping.lhs)
      end
    end
  end
end

clear_leader_prefix("d")
clear_leader_prefix("D")

local local_registers = { '"', "0", "1", "-" }

local function preserve_local_registers(callback)
  local saved = {}
  for _, register in ipairs(local_registers) do
    saved[register] = vim.fn.getreginfo(register)
  end

  callback()

  for register, info in pairs(saved) do
    vim.fn.setreg(register, info.regcontents or {}, info.regtype or "v")
  end
end

-- Operator used by <leader>y{motion}; only the + register is changed.
_G.NickYankToSystemClipboard = function(operator_type)
  local selection = operator_type == "line" and "'[V']" or operator_type == "block" and "`[\022`]" or "`[v`]"
  preserve_local_registers(function()
    vim.cmd("silent keepjumps normal! " .. selection .. '"+y')
  end)
end

map("n", "<leader>y", function()
  vim.go.operatorfunc = "v:lua.NickYankToSystemClipboard"
  return "g@"
end, { expr = true, desc = "Yank Motion to System Clipboard" })
map("x", "<leader>y", function()
  preserve_local_registers(function()
    vim.cmd('silent keepjumps normal! "+y')
  end)
end, { desc = "Yank Selection to System Clipboard" })
map("n", "<leader>Y", function()
  local line = vim.api.nvim_get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  set_linewise_register("+", line:sub(cursor[2] + 1))
  highlight_yanked_lines(cursor[1], cursor[1], cursor[2])
end, { desc = "Yank to End of Line to System Clipboard" })
map("n", "<leader>yy", function()
  set_linewise_register("+", { vim.api.nvim_get_current_line() })
  local line = vim.api.nvim_win_get_cursor(0)[1]
  highlight_yanked_lines(line, line)
end, { desc = "Yank Line to System Clipboard" })

map("n", "<leader>p", '"+p', { desc = "Paste System Clipboard After" })
map("n", "<leader>P", '"+P', { desc = "Paste System Clipboard Before" })
map("x", "<leader>p", '"_d"+P', { desc = "Replace Selection from System Clipboard" })
map("x", "<leader>P", '"_d"+P', { desc = "Replace Selection from System Clipboard" })

map("n", "<leader>d", '"_d', { desc = "Delete Motion into Nothing" })
map("x", "<leader>d", '"_d', { desc = "Delete Selection into Nothing" })
map("n", "<leader>D", '"_D', { desc = "Delete to End of Line into Nothing" })
map("n", "<leader>dd", '"_dd', { desc = "Delete Line into Nothing" })

-- Manual format + import organization. Auto-format/imports on save are disabled
-- (`vim.g.autoformat = false` in options.lua and no BufWritePre organizer), so
-- this is the only place they run. Normal mode formats then organizes imports
-- (which removes unused ones once you've finished editing); visual mode only
-- formats the selection.
local function organize_imports()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return
  end

  local enc = clients[1].offset_encoding or "utf-16"
  local params = vim.lsp.util.make_range_params(0, enc)

  local action_params = vim.tbl_extend("force", params, {
    context = { only = { "source.organizeImports" } },
  })

  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", action_params, 1000)

  for cid, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        local client = vim.lsp.get_client_by_id(cid)
        local client_enc = (client and client.offset_encoding) or "utf-16"
        vim.lsp.util.apply_workspace_edit(r.edit, client_enc)
      end
    end
  end
end

map("n", "<leader>cf", function()
  LazyVim.format({ force = true })
  organize_imports()
end, { desc = "Format & Organize Imports" })
map("x", "<leader>cf", function()
  LazyVim.format({ force = true })
end, { desc = "Format Selection" })

local function toggle_lsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients > 0 then
    vim.lsp.stop_client(clients)
    vim.notify("Stopped LSP clients for this buffer")
  else
    vim.cmd("doautocmd <nomodeline> FileType")
    vim.notify("Started LSP clients for this buffer")
  end
end

map("n", "<leader>tlsp", toggle_lsp, { desc = "Toggle LSP" })
map("n", "<leader>ti", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

-- Insert-mode conveniences.
map("i", "<CR>", function()
  local line = vim.api.nvim_get_current_line()
  local column = vim.api.nvim_win_get_cursor(0)[2]
  return line:sub(column, column) == ">" and line:sub(column + 1, column + 1) == "<" and "<CR><Esc>O" or "<CR>"
end, { expr = true, replace_keycodes = true, desc = "Expand Tags on Enter" })
map("i", "jj", "<Esc>")
map("i", "jk", "<Esc>")

map("n", "<leader>r", [[:%s/\<<C-r><C-w>\>//gcI<Left><Left><Left><Left>]], {
  desc = "Replace Word Under Cursor",
})
map("n", "<leader>rs", "<cmd>OverseerRunCmd npx expo start<cr>", { desc = "Start Metro/Expo" })
map("n", "<leader>ra", "<cmd>OverseerRunCmd npx expo run:android<cr>", { desc = "Run Android" })
