vim.g.loaded_netrwPlugin = 1

return {
	'stevearc/oil.nvim',
	lazy = false,
	cmd = {
		'Oil',
	},
	keys = {
		{ '-', '<cmd>Oil<cr>', desc = 'Open file explorer' }
	},
	opts = {
		win_options = {
			conceallevel = 0
		},
		keymaps = {
			['L'] = 'actions.select',
			['H'] = 'actions.parent',
			['<tab>'] = 'actions.preview',
			['-'] = 'actions.open_terminal',
			['q'] = 'actions.close',
			['<space>r'] = 'actions.refresh',
		},
		skip_confirm_for_simple_edits = true
	},
}
