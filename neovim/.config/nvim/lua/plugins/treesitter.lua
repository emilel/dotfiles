return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
		"nvim-treesitter/nvim-treesitter-context",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			highlight = { enable = true },
			indent = { enable = true, disable = { "python" } },
			incremental_selection = {
				enable = true,
				keymaps = {
					node_incremental = "<backspace>",
					node_decremental = "<delete>",
					scope_incremental = "+",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["a,"] = "@parameter.outer",
						["i,"] = "@parameter.inner",
						["ac"] = "@call.outer",
						["ic"] = "@call.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["al"] = "@class.outer",
						["il"] = "@class.inner",
					},
				},
				swap = {
					enable = true,
					swap_next = { [">,"] = "@parameter.outer" },
					swap_previous = { ["<,"] = "@parameter.inner" },
				},
			},
		})

		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		vim.opt.foldlevelstart = 99
		vim.opt.foldlevel = 99

		require("treesitter-context").disable()
		vim.keymap.set("n", "\\c", function()
			require("treesitter-context").toggle()
		end, { desc = "toggle treesitter context" })
	end,
}
