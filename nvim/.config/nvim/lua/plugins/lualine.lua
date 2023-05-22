return {
	'nvim-lualine/lualine.nvim',
	opts = {
		options = {
			icons_enabled = false,
			theme = 'gruvbox',
			component_separators = '|',
			section_separators = '',
		},
		sections = {
			lualine_a = { 'mode' },
			lualine_b = {
				function()
					local last
					for token in os.getenv("PWD"):gmatch("/[^/]*") do
						last = token:sub(2)
					end

					return last
				end,
				'branch'
			},
			lualine_c = { { 'filename', path = 1 } },
		}
	},
}