return {
	'tpope/vim-surround',
	keys = {
		{ 's',  '<plug>VSurround', mode = 'v',                 desc = "Surround selection" },
		{ 'ds', '<plug>Dsurround', desc = "Delete surrounding" },
		{ 'cs', '<plug>Csurround', desc = "Change surrounding" },
	},
	config = function() vim.g.surround_no_mappings = 1 end
}
