return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	lazy = false,
	opts = {},
	keys = {
		{
			"<space>e",
			":Refactor extract",
			desc = "Refactor selection",
			mode = "x",
		},
	},
}
