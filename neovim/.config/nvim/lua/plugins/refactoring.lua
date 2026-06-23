return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"lewis6991/async.nvim",
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
