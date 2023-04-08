local python_group = vim.api.nvim_create_augroup(
	'python',
	{ clear = true }
)
vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'python',
		group = python_group,
		callback = function()
			vim.keymap.set('n', '<space>r', '<cmd>silent !tmux send-keys -t "run.1" "python " % Enter<cr>',
				{ desc = 'Run file in tmux window "run"', buffer = true })
			vim.keymap.set('n', '<space>R', '<cmd>silent !tmux send-keys -t "run.1" "python -i " % Enter<cr>',
				{ desc = 'Run file in tmux window "run and end in interactive mode"', buffer = true })
			vim.keymap.set('n', '<bs>r', '<cmd>silent !tmux send-keys -t "run.1" C-d "python " % Enter<cr>',
				{ desc = 'Press C-d and run file in tmux window "run"', buffer = true })
			vim.keymap.set('n', '<bs>R',
				'<cmd>silent !tmux send-keys -t "run.1" C-d "python -i " % Enter<cr>',
				{
					desc = 'Press C-d and run file in tmux window "run" and end in interactive mode',
					buffer = true
				})
			vim.keymap.set('n', '<space>z',
				':let view = winsaveview()<cr>:write<cr>:silent !black %<cr>:silent !isort %<cr>:edit<cr>:call winrestview(view)<cr>',
				{ desc = 'Run black and isort on current file', buffer = true })
			vim.keymap.set('n', '<space>x', ':silent write<cr>:silent !autoflake %<cr>',
				{ desc = 'Run autoflake on current file', buffer = true })
			vim.keymap.set('n', ',dd', 'opdb.set_trace()<esc>ggoimport pdb<esc><c-o>',
				{ desc = 'Debug here.', buffer = true })
			vim.keymap.set('n', ',DD',
				':let view = winsaveview()<cr>:g/\\(import pdb\\|pdb.set_trace()\\)/d<cr><cmd>noh<cr>:call winrestview(view)<cr>',
				{ desc = 'Remove debug lines', buffer = true })
		end
	}
)
