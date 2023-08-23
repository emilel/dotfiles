return {
	"danielfalk/smart-open.nvim",
	branch = "0.2.x",
	config = function()
		require("telescope").load_extension("smart_open")
		-- require('telescope').extensions.smart_open.smart_open({
		-- 	cwd_only = true,
		-- })
		vim.keymap.set('n', '<space>a',
			"<cmd>lua require('telescope').extensions.smart_open.smart_open({cwd_only = true})<cr>", {
				desc = 'Search files in current working directory'
			}
		)
		vim.keymap.set('n', '<space>A',
			"<cmd>lua require('telescope').extensions.smart_open.smart_open({cwd_only = false})<cr>", {
				desc = 'Search files globally'
			}
		)
	end,
	dependencies = {
		"kkharji/sqlite.lua",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
}
