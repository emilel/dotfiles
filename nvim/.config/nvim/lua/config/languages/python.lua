vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'python',
		group = vim.api.nvim_create_augroup(
			'python',
			{ clear = true }
		),
		callback = function()
			vim.keymap.set('v', '<c-j>', ':m \'>+1<cr>gv', {desc = 'Move line down'})
			vim.keymap.set('v', '<c-k>', ':m \'<-2<cr>gv', { desc = 'Move line up' })
			vim.keymap.set('n', '<space>yr', '<cmd>silent let @+ = \'py ./\' . fnamemodify(expand("%"), ":~:.")<cr>',
			{ desc = 'Copy command to run file' })
			vim.keymap.set('n', '<cr>r', '<cmd>silent !tmux send-keys -t "run.bottom-right" "python " % Enter<cr>',
				{ desc = 'Run file in tmux window "run"', buffer = true })
			vim.keymap.set('n', '<cr>R', '<cmd>silent !tmux send-keys -t "run.bottom-right" "python -i " % Enter<cr>',
				{ desc = 'Run file in tmux window "run and end in interactive mode"', buffer = true })
			vim.keymap.set('n', '<delete>r', '<cmd>silent !tmux send-keys -t "run.1" C-d "python " % Enter<cr>',
				{ desc = 'Press C-d and run file in tmux window "run"', buffer = true })
			vim.keymap.set('n', '<delete>R',
				'<cmd>silent !tmux send-keys -t "run.1" C-d "python -i " % Enter<cr>',
				{
					desc = 'Press C-d and run file in tmux window "run" and end in interactive mode',
					buffer = true
				})
			vim.keymap.set('n', '<space>z',
				':silent let view = winsaveview()<cr>:write<cr>:silent !black %<cr>:silent !isort %<cr>:edit<cr>:silent call winrestview(view)<cr>',
				{ desc = 'Run black and isort on current file', buffer = true, silent = true })
			vim.keymap.set('n', '<space>x', ':silent write<cr>:silent !autoflake %<cr>',
				{ desc = 'Run autoflake on current file', buffer = true, silent = true })
			vim.keymap.set('n', ',di', 'o__import__("pdb").set_trace()<esc>',
				{ desc = 'Debug here.', buffer = true })
			vim.keymap.set('n', ',dd',
				':let view = winsaveview()<cr>:g/__import__("pdb").set_trace()/d<cr><cmd>noh<cr>:call winrestview(view)<cr>',
				{ desc = 'Remove debug lines', buffer = true })
			vim.keymap.set('v', '<space>f', '<esc>`>a}"<esc>`<if"{<esc>', { desc = 'Surround in f-string' })
		end
	}
)
