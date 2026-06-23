return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"lewis6991/async.nvim",
	},
	cmd = "Refactor",
	keys = {
		{
			"<space>e",
			":Refactor extract",
			desc = "Refactor selection",
			mode = "x",
		},
	},
	opts = {},
}
