vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'julia',
		group = vim.api.nvim_create_augroup(
			'julia',
			{ clear = true }
		),
		callback = function()
			vim.keymap.set('n', '<space>r',
				'<cmd>silent !tmux send-keys -t "run.bottom-right" C-c "include(\\"" %:p "\\")" Enter<cr>',
				{ desc = 'Run file in tmux window "run"', buffer = true })
			vim.keymap.set('n', ',dd', 'o@infiltrate<esc>ggOusing Infiltrator<esc><c-o>',
				{ desc = 'Debug here.', buffer = true })
			vim.keymap.set('n', ',DD',
				':let view = winsaveview()<cr>:g/\\(@infiltrate\\|using Infiltrator\\)/d<cr><cmd>noh<cr>:call winrestview(view)<cr>',
				{ desc = 'Remove debug lines', buffer = true, silent = true })
			vim.keymap.set('n', '<space>z',
				'<cmd>silent !tmux send-keys -t "run.bottom-right" "using JuliaFormatter; format_file(\\"" %:p "\\")" Enter<cr>',
				{ desc = 'Format julia file' })
			vim.keymap.set('i', '<c-a>', '<cmd>lua require("config.functions").insert_path({rel="file"})<cr>',
				{ desc = 'Insert path', buffer = true })
		end
	}
)
