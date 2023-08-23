vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'text',
		group = vim.api.nvim_create_augroup(
			'text',
			{ clear = true }
		),
		callback = function()
			vim.keymap.set( 'n' , '<cr>', '<nop>', {
				silent = true,
				desc
				= 'Don\t always use Slime',
				buffer = true
			})
			vim.keymap.set('n', '<cr><cr>', '<cmd>wq<cr>',
				{ desc = 'Save and close file', buffer = true })
		end
	}
)
