vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'markdown',
		group = vim.api.nvim_create_augroup(
			'markdown',
			{ clear = true }
		),
		callback = function()
			vim.opt_local.textwidth = 80
			vim.opt_local.colorcolumn = '81'
			vim.opt_local.spell = true
			vim.opt_local.spelllang = 'en_us'
			vim.keymap.set('n', '<space>z', 'gwap', { desc = 'Format paragraph', buffer = true })
			vim.keymap.set('n', '<space>Z', 'mygggqG`y', { desc = 'Format file', buffer = true })
			vim.keymap.set("n", ",ca", function()
				require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor({}))
			end, { desc = 'Spelling Suggestions', buffer = true })
		end
	}
)
