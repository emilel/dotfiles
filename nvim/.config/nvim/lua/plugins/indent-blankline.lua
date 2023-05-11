vim.api.nvim_set_hl(0, 'IndentBlanklineContextChar', { fg = 'gray', bold = true })

return {
	'lukas-reineke/indent-blankline.nvim',
	opts = {
		char = '┊',
		context_char = '┊',
		show_trailing_blankline_indent = false,
		show_current_context = true,
		show_current_context_start = false,
	},
}
