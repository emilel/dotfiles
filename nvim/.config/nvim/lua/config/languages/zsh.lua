vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'zsh',
		group = vim.api.nvim_create_augroup(
			'zsh',
			{ clear = true }
		),
		callback = function()
			vim.keymap.set('n', '<space><space>', '<cmd>wq<cr>',
				{ desc = 'Save and close file', buffer = true })
		end
	}
)


