vim.api.nvim_create_autocmd(
	'BufEnter',
	{
		callback = function()
			vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = "lightgreen" })
			vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = "lightblue" })
			vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = "lightred" })
		end,
		group = vim.api.nvim_create_augroup(
			'shit',
			{ clear = true }
		)
	}
)

return {
	'lewis6991/gitsigns.nvim',
	opts = {
		signs = {
			add = { text = '+' },
			change = { text = '~' },
			delete = { text = '_' },
			topdelete = { text = '‾' },
			changedelete = { text = '~' },
		},
		sign_priority = 1000
	},
}
