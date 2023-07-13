vim.api.nvim_create_autocmd(
	'BufEnter',
	{
		group = vim.api.nvim_create_augroup(
			'colorcolumn',
			{ clear = true }
		),
		callback = function()
			vim.opt_local.colorcolumn = tostring(vim.opt_local.textwidth._value + 1)
		end
	}
)
