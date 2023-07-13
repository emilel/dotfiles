vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'sh',
		group = vim.api.nvim_create_augroup(
			'sh',
			{ clear = true }
		),
		callback = function()
			vim.keymap.set('n', '<space>yr', '<cmd>let @+ = \'sh ./\' . fnamemodify(expand("%"), ":~:.")<cr>',
			{ desc = 'Copy command to run shell file' })
			vim.keymap.set('n', '<cr>r', '<cmd>silent !tmux send-keys -t "run.bottom-right" "sh " % Enter<cr>',
				{ desc = 'Run file in tmux window "run"', buffer = true })
		end
	}
)


