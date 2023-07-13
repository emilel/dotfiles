vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'gitcommit',
		group = vim.api.nvim_create_augroup(
			'gitcommit',
			{ clear = true }
		),
		callback = function()
			vim.keymap.set('n', '<cr><cr>', '<cmd>wq<cr>',
				{ desc = 'Save and close file', buffer = true })
			vim.keymap.set('n', '<cr>', '<nop>', { desc = 'Disable slime', buffer = true })
		end
	}
)

