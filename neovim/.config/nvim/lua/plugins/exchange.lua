vim.g.exchange_no_mappings = 1

return {
	"tommcdo/vim-exchange",
	keys = {
		{ "X", "<Plug>(Exchange)", mode = "x", desc = "Exchange selection" },
	},
}
