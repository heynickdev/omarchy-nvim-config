return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#13140a',
				base01 = '#13140a',
				base02 = '#a598a0',
				base03 = '#a598a0',
				base04 = '#ffeff9',
				base05 = '#fff8fc',
				base06 = '#fff8fc',
				base07 = '#fff8fc',
				base08 = '#ff9fa6',
				base09 = '#ff9fa6',
				base0A = '#ffbae4',
				base0B = '#beffa5',
				base0C = '#ffdaf0',
				base0D = '#ffbae4',
				base0E = '#ffc6e9',
				base0F = '#ffc6e9',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#a598a0',
				fg = '#fff8fc',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#ffbae4',
				fg = '#13140a',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#a598a0' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffdaf0', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#ffc6e9',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#ffbae4',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#ffbae4',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#ffdaf0',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#beffa5',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#ffeff9' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#ffeff9' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#a598a0',
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
