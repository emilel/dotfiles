vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'markdown',
		group = vim.api.nvim_create_augroup(
			'markdown',
			{ clear = true }
		),
		callback = function()
			vim.opt.textwidth = 80
			vim.opt.colorcolumn = '81'
			-- vim.opt_local.spell = true
			vim.api.nvim_buf_create_user_command(0, 'Lang', function(arg)
				if arg.fargs[1] == 'swe' then
					vim.opt_local.spelllang = 'sv'
				elseif arg.fargs[1] == 'eng' then
					vim.opt_local.spelllang = 'en_us'
				end
			end, { nargs = 1 })
			vim.opt_local.spelllang = 'en_us'
			vim.keymap.set('n', '<space>z', 'gwap', { desc = 'Format paragraph' })
			vim.keymap.set("n", ",ca", function()
				require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor({}))
			end, { desc = 'Spelling Suggestions' })
		end
	}
)
