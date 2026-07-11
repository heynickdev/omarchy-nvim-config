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

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    pcall(vim.keymap.del, "n", "<leader>e")
    pcall(vim.keymap.del, "n", "<leader>E")

    vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle reveal<CR>", {
      desc = "Toggle Neo-tree",
      noremap = true,
      silent = true,
    })

    vim.keymap.set("n", "<leader>E", function()
      local current_file = vim.api.nvim_buf_get_name(0)

      if current_file ~= "" then
        local dir = vim.fn.fnamemodify(current_file, ":p:h")
        vim.cmd("Explore " .. vim.fn.fnameescape(dir))
      else
        vim.cmd("Explore")
      end
    end, {
      desc = "Open netrw",
      noremap = true,
      silent = true,
    })
  end,
})

-- --- ORGANIZE IMPORTS ON SAVE (Go, Svelte, TS, JS, Vue) ---
local function organize_imports()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return
  end

  local enc = clients[1].offset_encoding or "utf-16"
  local params = vim.lsp.util.make_range_params(0, enc)

  -- Use tbl_extend to avoid lua_ls strict typing warnings
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

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go", "*.svelte", "*.ts", "*.js", "*.vue" },
  callback = organize_imports,
})

-- Autocmds are automatically loaded on the VeryLazy event.

local terminal_group = vim.api.nvim_create_augroup("UserTerminalBottom", {
  clear = true,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = terminal_group,
  callback = function(event)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(event.buf) then
        return
      end

      local win = vim.fn.bufwinid(event.buf)

      if win == -1 then
        return
      end

      local config = vim.api.nvim_win_get_config(win)

      if config.relative ~= "" then
        return
      end

      vim.api.nvim_set_current_win(win)
      vim.cmd("wincmd J")
      vim.cmd("resize 15")

      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.wo.signcolumn = "no"

      vim.cmd("startinsert")
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "man",
  callback = function()
    -- Link dull man page highlights to vibrant code highlights
    vim.api.nvim_set_hl(0, 'manTitle', { link = 'Keyword', default = false })
    vim.api.nvim_set_hl(0, 'manSectionHeading', { link = 'Function', default = false })
    vim.api.nvim_set_hl(0, 'manOptionDesc', { link = 'String', default = false })
    vim.api.nvim_set_hl(0, 'manReference', { link = 'Type', default = false })
  end,
})

-- --- UI TRANSPARENCY FIX ---
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local transparent_groups = {
      "NormalFloat",     -- Floating windows
      "FloatBorder",     -- Borders of floating windows
      "NeoTreeNormal",   -- Neo-tree background
      "NeoTreeNormalNC", -- Neo-tree background (non-current)
      "WinSeparator",    -- The vertical split line
      "VertSplit",       -- Legacy vertical split line
    }

    for _, group in ipairs(transparent_groups) do
      -- Force the background to be completely transparent
      vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
    end
    
    -- Optional: Dim the bright vertical separator line so it's less harsh
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#565f89", bg = "NONE" }) 
  end,
})
