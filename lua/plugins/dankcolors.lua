return {
<<<<<<< Updated upstream
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#131318',
				base01 = '#131318',
				base02 = '#999aa5',
				base03 = '#999aa5',
				base04 = '#eff0ff',
				base05 = '#f8f9ff',
				base06 = '#f8f9ff',
				base07 = '#f8f9ff',
				base08 = '#ff9fb7',
				base09 = '#ff9fb7',
				base0A = '#c6cbff',
				base0B = '#a5ffb5',
				base0C = '#e1e3ff',
				base0D = '#c6cbff',
				base0E = '#d0d4ff',
				base0F = '#d0d4ff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#999aa5',
				fg = '#f8f9ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#c6cbff',
				fg = '#131318',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#999aa5' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#e1e3ff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#d0d4ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#c6cbff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#c6cbff',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#e1e3ff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a5ffb5',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#eff0ff' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#eff0ff' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#999aa5',
				italic = true
			})
=======
  {
    "RRethy/base16-nvim",
    lazy = false,
    priority = 10000,
    config = function()
      local function apply_theme()
        vim.opt.termguicolors = true

        require("base16-colorscheme").setup({
          base00 = "#11131c",
          base01 = "#11131c",
          base02 = "#999ba5",
          base03 = "#999ba5",
          base04 = "#eff2ff",
          base05 = "#f8f9ff",
          base06 = "#f8f9ff",
          base07 = "#f8f9ff",
          base08 = "#ff9fb8",
          base09 = "#fffba5",
          base0A = "#c0ccff",
          base0B = "#a5ffb4",
          base0C = "#dee4ff",
          base0D = "#c0ccff",
          base0E = "#cbd5ff",
          base0F = "#cbd5ff",
        })

        local bg = "#11131c"
        local fg = "#f8f9ff"
        local muted = "#999ba5"
        local blue = "#c0ccff"
        local cyan = "#dee4ff"
        local green = "#a5ffb4"
        local red = "#ff9fb8"
        local purple = "#cbd5ff"

        -- Transparent main editor so your DMS/wallpaper blur shows through
        local transparent_groups = {
          "Normal",
          "NormalNC",
          "SignColumn",
          "EndOfBuffer",
          "LineNr",
          "FoldColumn",
          "CursorLine",
          "CursorLineNr",
          "StatusLine",
          "StatusLineNC",
          "WinSeparator",
        }

        for _, group in ipairs(transparent_groups) do
          vim.api.nvim_set_hl(0, group, { bg = "NONE" })
        end

        -- Keep popups readable
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = bg, fg = blue })
        vim.api.nvim_set_hl(0, "Pmenu", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = blue, fg = bg, bold = true })

        -- Nice editor highlights
        vim.api.nvim_set_hl(0, "Visual", { bg = muted, fg = fg, bold = true })
        vim.api.nvim_set_hl(0, "Search", { bg = blue, fg = bg, bold = true })
        vim.api.nvim_set_hl(0, "IncSearch", { bg = purple, fg = bg, bold = true })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = cyan, bg = "NONE", bold = true })
        vim.api.nvim_set_hl(0, "Comment", { fg = muted, italic = true })

        vim.api.nvim_set_hl(0, "Function", { fg = blue, bold = true })
        vim.api.nvim_set_hl(0, "Keyword", { fg = purple, bold = true })
        vim.api.nvim_set_hl(0, "Statement", { fg = purple, bold = true })
        vim.api.nvim_set_hl(0, "Type", { fg = cyan, bold = true })
        vim.api.nvim_set_hl(0, "String", { fg = green })
        vim.api.nvim_set_hl(0, "DiagnosticError", { fg = red })
        vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#fffba5" })
        vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = blue })
        vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = cyan })
>>>>>>> Stashed changes

        -- Lazy / Mason / WhichKey style
        vim.api.nvim_set_hl(0, "LazyNormal", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "MasonNormal", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = bg, fg = fg })
      end

      vim.schedule(apply_theme)

      -- Auto reload when DMS regenerates this file
      local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"

      if not _G.__dms_neovim_theme_watcher then
        local uv = vim.uv or vim.loop
        _G.__dms_neovim_theme_watcher = uv.new_fs_event()

        _G.__dms_neovim_theme_watcher:start(
          current_file_path,
          {},
          vim.schedule_wrap(function()
            local ok, new_spec = pcall(dofile, current_file_path)

            if ok and new_spec and new_spec[1] and new_spec[1].config then
              new_spec[1].config()
              vim.notify("DMS Neovim theme reloaded", vim.log.levels.INFO)
            end
          end)
        )
      end
    end,
  },
}
