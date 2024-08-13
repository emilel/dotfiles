return {
	'tpope/vim-surround',
	lazy = true,
	keys = {
		{ 's', '<plug>VSurround', mode = 'x', desc = "Surround selection" },
		{ 'ds', '<plug>Dsurround', mode = 'n', 'Delete surrounding' },
		{ 'cs', '<plug>Csurround', mode = 'n', 'Change surrounding' }
	},
	config = function()
		vim.g.surround_no_mappings = 1
	end
}
