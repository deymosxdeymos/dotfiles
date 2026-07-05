return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#100F0F',
				base01 = '#100F0F',
				base02 = '#73797f',
				base03 = '#73797f',
				base04 = '#b8c0c7',
				base05 = '#f6fbff',
				base06 = '#f6fbff',
				base07 = '#f6fbff',
				base08 = '#ff83a8',
				base09 = '#ff83a8',
				base0A = '#5d9bd1',
				base0B = '#7ce489',
				base0C = '#b4dcff',
				base0D = '#5d9bd1',
				base0E = '#87c3f6',
				base0F = '#87c3f6',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#73797f',
				fg = '#f6fbff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#5d9bd1',
				fg = '#100F0F',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#73797f' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#b4dcff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#87c3f6',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#5d9bd1',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#5d9bd1',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#b4dcff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#7ce489',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#b8c0c7' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#b8c0c7' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#73797f',
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
