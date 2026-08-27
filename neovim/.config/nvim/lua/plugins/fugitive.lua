return {
	"tpope/vim-fugitive",
	cmd = "Git",
	keys = {
		{ "<c-g><c-g>", "<cmd>Git<cr><cmd>only<cr>", desc = "Open git" },
		{ "<c-g><c-c>", "<cmd>Git commit<cr>", desc = "Git commit" },
		-- puLL: <c-g><c-j> is gitsigns' changed-files quickfix.
		{ "<c-g><c-l>", "<cmd>Git pull<cr>", desc = "Git pull" },
		{ "<c-g><c-k>", "<cmd>Git push<cr>", desc = "Git push" },
		{ "<c-g> ", ":Git ", desc = "Run git command" },
	},
}
