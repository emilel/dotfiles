vim.api.nvim_create_autocmd(
	'BufEnter',
	{
		group = vim.api.nvim_create_augroup(
			'conceallevel',
			{ clear = true }
		),
		callback = function()
			vim.opt_local.conceallevel = 0
		end
	}
)


