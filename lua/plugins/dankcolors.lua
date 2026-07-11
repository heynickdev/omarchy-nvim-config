return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#0f1416',
				base01 = '#0f1416',
				base02 = '#8c9497',
				base03 = '#8c9497',
				base04 = '#e5f1f4',
				base05 = '#f8fdff',
				base06 = '#f8fdff',
				base07 = '#f8fdff',
				base08 = '#ff9fbf',
				base09 = '#ff9fbf',
				base0A = '#a2e8ff',
				base0B = '#a5ffaf',
				base0C = '#cef3ff',
				base0D = '#a2e8ff',
				base0E = '#b3ecff',
				base0F = '#b3ecff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#8c9497',
				fg = '#f8fdff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#a2e8ff',
				fg = '#0f1416',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#8c9497' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#cef3ff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#b3ecff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#a2e8ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#a2e8ff',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#cef3ff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a5ffaf',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#e5f1f4' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#e5f1f4' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#8c9497',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
