return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	event = { "BufReadPost", "BufNewFile" },
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
					-- <backspace> is reserved for toggling folds (see keymaps/navigation.lua).
					init_selection = "+",
					node_incremental = "+",
					node_decremental = "-",
					scope_incremental = false,
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

		-- Fold options live in core/options.lua (using the built-in treesitter foldexpr).

		require("treesitter-context").disable()
		vim.keymap.set("n", "\\c", function()
			require("treesitter-context").toggle()
		end, { desc = "toggle treesitter context" })
	end,
}
