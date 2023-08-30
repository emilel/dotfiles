vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'julia',
		group = vim.api.nvim_create_augroup(
			'julia',
			{ clear = true }
		),
		callback = function()
			vim.opt_local.textwidth = 92
			vim.opt_local.colorcolumn = "93"
			vim.opt_local.expandtab = true
			vim.keymap.set('n', '<cr>r',
				':silent !tmux send-keys -t "run.bottom-right" "include(\\"" %:p "\\")\\;" Enter<cr>',
				{ desc = 'Reload and run file in tmux window "run"', buffer = true, silent = true })
			vim.keymap.set('n', '<cr>R',
				':silent !tmux send-keys -t "run.bottom-right" "include(\\"src/scripts/rund.jl\\")\\;" Enter<cr>',
				{ desc = 'Run file in tmux window "run"', buffer = true, silent = true })
			vim.keymap.set('n', '<cr>t', ':silent !tmux send-keys -t "run.bottom-right" "@toggle" Enter C-c<cr>',
				{ desc = "Toggle break point", buffer = true, silent = true })
			vim.keymap.set('n', '<cr>e', ':silent !tmux send-keys -t "run.bottom-right" "@exit" Enter C-c<cr>',
				{ desc = "Exit break point", buffer = true, silent = true })
			vim.keymap.set('n', ',di', 'oMain.@infiltrate<esc>',
				{ desc = 'Debug here', buffer = true, silent = true })
			vim.keymap.set('n', ',de', 'oMain.@exfiltrate<esc>',
				{ desc = 'Debug here', buffer = true, silent = true })
			vim.keymap.set('n', ',dd',
				':silent let view = winsaveview()<cr>:g/\\(Main.@infiltrate\\|Main.@exfiltrate\\)/d<cr><cmd>noh<cr>:call winrestview(view)<cr>',
				{ desc = 'Remove debug lines', buffer = true, silent = true })
			vim.keymap.set('n', '<space>z',
				'<cmd>silent !tmux send-keys -t "repl.bottom-right" "format_file(\\"" %:p "\\")" Enter<cr>',
				{ desc = 'Format julia file', buffer = true, silent = true })
			vim.keymap.set('i', '<c-a>', '<cmd>lua require("config.functions").insert_path({rel="file"})<cr>',
				{ desc = 'Insert path', buffer = true, silent = true })
			vim.keymap.set('n', '<space>yr', ':silent let @+ = \'include(\"\' . expand("%:p") . \'\");\'<cr>',
				{ desc = 'Copy command to run file', buffer = true, silent = true })
			vim.keymap.set('n', '<space>yR', ':silent let @+ = \'include(\"src/scripts/rund.jl\")\\;\'<cr>',
				{ desc = 'Copy command to run main', buffer = true, silent = true })
		end
	}
)
