return {
	"tpope/vim-surround",
	-- globals must be set before the plugin loads, so use init (runs at startup)
	init = function()
		vim.g.surround_no_mappings = 1
		vim.g.surround_99 = "```\r```" -- create a code block with cs<motion>` -> c
	end,
	keys = {
		{ "s", "<plug>VSurround", mode = "x", desc = "Surround selection" },
		{ "ds", "<plug>Dsurround", desc = "Delete surrounding" },
		{ "cs", "<plug>Csurround", desc = "Change surrounding" },
	},
}
