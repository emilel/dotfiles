return {
	'ThePrimeagen/harpoon',
	keys = {
		{ '<space>\'', '<cmd>lua require("harpoon.mark").add_file()<cr>',        desc = 'Add to marked files' },
		{ '<space>;',  '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', desc = 'Open marked files' },
		{ '<c-j>',     '<cmd>lua require("harpoon.ui").nav_next()<cr>',          desc = 'Go to next marked file' },
		{
			'<c-k>',
			'<cmd>lua require("harpoon.ui").nav_prev()<cr>',
			desc =
			'Go to previous marked file'
		}
	},
	dependencies = { 'nvim-lua/plenary.nvim' }
}
