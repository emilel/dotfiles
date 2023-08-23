vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'tex',
		group = vim.api.nvim_create_augroup(
			'latex',
			{ clear = true }
		),
		callback = function()
			vim.opt_local.shiftwidth = 4


			vim.keymap.set('n', '<cr>r',
				':silent !tmux send-keys -t "shell.bottom-right" "pdflatex --output-directory " %:h \\ %:p Enter<cr>',
				{
					desc = 'Compile document in tmux window "shell"',
					buffer = true,
					silent =
						true
				})

			vim.keymap.set('n', '<space>z', 'gwap', { desc = 'Format paragraph', buffer = true })
			vim.keymap.set('n', '<space>Z', 'mygggqG`y', { desc = 'Format file', buffer = true })
			vim.keymap.set("n", ",ca", function()
				require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor({}))
			end, { desc = 'Spelling Suggestions', buffer = true })
		end
	}
)
