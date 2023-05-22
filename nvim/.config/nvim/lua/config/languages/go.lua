vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'go',
		group = vim.api.nvim_create_augroup(
			'go',
			{ clear = true }
		),
		callback = function()
			vim.keymap.set('n', '<space>yr', '<cmd>let @+ = \'go run ./\' . fnamemodify(expand("%"), ":~:.")<cr>',
			{ desc = 'Copy command to run file' })
			vim.keymap.set('n', '<space>r', '<cmd>silent !tmux send-keys -t "run.bottom-right" "go run ." Enter<cr>',
				{ desc = 'Run file in tmux window "run"', buffer = true })
		end
	}
)

