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
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      npairs.setup(opts)

      -- A. Rule for Templ/HTML: Expand <div>|</div>
      npairs.add_rules({
        Rule(">", "<", { "templ", "html", "vue", "svelte", "markdown" })
          :with_pair(cond.not_before_regex("/>"))
          :with_pair(cond.not_after_regex("^%s*>")),
      })

      -- B. Important: Connect Autopairs to CMP (fixes behavior after accepting suggestions)
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- 3. Treesitter: Ensure Go & Templ are installed and Indent is ON
  -- 4. Treesitter & Hybrid Indentation
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.filetype.add({ extension = { templ = "templ" } })

      -- Define a custom hybrid indent function
      -- It checks: Did I just type a Go brace '{'? -> Indent
      -- Otherwise: Use standard HTML indent rules
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "templ",
        callback = function()
          -- Load HTML indent rules so we can call them
          vim.cmd("runtime! indent/html.vim")

          -- Global function for templ indentation
          _G.TemplIndent = function()
            local lnum = vim.v.lnum
            local prev_lnum = vim.fn.prevnonblank(lnum - 1)
            local prev_line = vim.fn.getline(prev_lnum)

            -- 1. If previous line ends in '{', increase indent (Go-style)
            if prev_line:match("{$") then
              return vim.fn.indent(prev_lnum) + vim.fn.shiftwidth()
            end

            -- 2. If current line is '}', decrease indent (Go-style)
            local cur_line = vim.fn.getline(lnum)
            if cur_line:match("^%s*}$") then
              return vim.fn.indent(prev_lnum) - vim.fn.shiftwidth()
            end

            -- 3. Otherwise, delegate to the standard HTML indenter
            return vim.fn.HtmlIndent()
          end

          -- Apply the custom function
          vim.opt_local.indentexpr = "v:lua.TemplIndent()"
          vim.opt_local.smartindent = false -- Turn off to avoid conflicts
        end,
      })
    end,
    -- (Keep the opts section the same)
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
      -- opts.servers.htmx = { filetypes = { "html", "templ" } }
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

