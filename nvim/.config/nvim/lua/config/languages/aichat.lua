vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'aichat',
		group = vim.api.nvim_create_augroup(
			'aichat',
			{ clear = true }
		),
		callback = function()
			vim.keymap.set({ 'n', 'v' }, '<cr>', '<nop>', {
				silent = true,
				desc
				       = 'Don\t always use Slime',
				buffer = true
			})
			vim.keymap.set('n', '<cr><cr>', '<cmd>AIChat<cr><cmd>write<cr>', { desc = 'Send message', buffer = true })
			vim.opt_local.colorcolumn = "0"
			vim.opt_local.textwidth = 80
		end
	}
)
