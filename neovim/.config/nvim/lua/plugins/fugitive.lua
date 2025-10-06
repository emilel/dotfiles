return {
	"tpope/vim-fugitive",
	lazy = false,
	keys = {
		{ "<c-g><c-g>", "<cmd>Git<cr><cmd>only<cr>", desc = "Open git" },
		{ "<c-g>j", "<cmd>Git pull<cr>", desc = "Git pull" },
		{ "<c-g>k", "<cmd>Git push<cr>", desc = "Git push" },
	},
}
