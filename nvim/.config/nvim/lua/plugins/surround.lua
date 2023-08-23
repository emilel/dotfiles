-- surround with newline
vim.cmd([[let g:surround_{char2nr("\<CR>")} = "\n\r\n"]])

return {
	'tpope/vim-surround',
	keys = {
		{ 's',  '<plug>VSurround', mode = 'x',                 desc = "Surround selection" },
		{ 'ds', '<plug>Dsurround', desc = "Delete surrounding" },
		{ 'cs', '<plug>Csurround', desc = "Change surrounding" },
	},
	config = function() vim.g.surround_no_mappings = 1 end
}
