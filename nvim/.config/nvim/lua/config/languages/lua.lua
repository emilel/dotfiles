vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'lua',
		group = vim.api.nvim_create_augroup(
			'lua',
			{ clear = true }
		),
		callback = function()
			vim.opt_local.textwidth = 0
			vim.opt_local.colorcolumn = "0"
		end
	}
)
