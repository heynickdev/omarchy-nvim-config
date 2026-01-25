return {
  -- 1. Disable mini.pairs (LazyVim default)
  { "nvim-mini/mini.pairs", enabled = false },

  -- 2. Install nvim-autopairs & Integrate with CMP
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    opts = {
      check_ts = true, -- Check treesitter
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      -- Rule and cond are no longer needed for the manual tag rule

      npairs.setup(opts)

      -- REMOVED: The manual Rule(">", "<") that was causing the ghost '<' input.
      -- nvim-ts-autotag (configured below) will handle closing your HTML/Templ tags properly.

      -- B. Important: Connect Autopairs to CMP
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      -- Note: Ensure you are using 'blink.cmp' or 'cmp' as per your lockfile
      local status, cmp = pcall(require, "cmp")
      if status then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- 3. Treesitter: Ensure Go & Templ are installed and Indent is ON
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.filetype.add({ extension = { templ = "templ" } })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "templ",
        callback = function()
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
        end,
      })
    end,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "templ", "html", "go", "gomod" })
      opts.indent = opts.indent or {}
      opts.indent.enable = true
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.templ = {}
      opts.servers.emmet_language_server = {
        filetypes = {
          "css",
          "eruby",
          "html",
          "javascript",
          "javascriptreact",
          "less",
          "sass",
          "scss",
          "svelte",
          "pug",
          "typescriptreact",
          "vue",
          "templ",
        },
        init_options = {
          includeLanguages = { templ = "html" },
          showExpandedAbbreviation = "always",
          showAbbreviationSuggestions = true,
          showSuggestionsAsSnippets = true,
        },
      }
    end,
  },
}
