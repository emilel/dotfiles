vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'zsh',
		group = vim.api.nvim_create_augroup(
			'zsh',
			{ clear = true }
		),
		callback = function()
			vim.keymap.set('n', '<space>yr', '<cmd>let @+ = \'source \' . expand("%:p")<cr>',
				{ desc = 'Copy command to source file' })
			vim.keymap.set('n', '<cr><cr>', '<cmd>wq<cr>',
				{ desc = 'Save and close file', buffer = true })
			vim.keymap.set('n', '<cr>', '<nop>', { desc = 'Disable slime', buffer = true })
		end
	}
)
