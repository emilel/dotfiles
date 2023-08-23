vim.api.nvim_create_autocmd(
	'BufEnter',
	{
		group = vim.api.nvim_create_augroup(
			'formatoptions',
			{ clear = true }
		),
		callback = function()
			vim.opt_local.formatoptions = {}
			vim.opt_local.formatoptions:append('2')
			vim.opt_local.formatoptions:append('j')
			vim.opt_local.formatoptions:append('c')
			-- vim.opt_local.formatoptions:append('r')
			vim.opt_local.formatoptions:append('q')
			-- vim.opt_local.formatoptions:append('l')
			vim.opt_local.formatoptions:append('t')
		end
	}
)

