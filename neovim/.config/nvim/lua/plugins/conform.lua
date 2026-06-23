return {
	"stevearc/conform.nvim",
	cmd = "ConformInfo",
	keys = {
		{
			"<space>z",
			function()
				require("conform").format({ lsp_fallback = true })
			end,
			mode = { "n", "x" },
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
			zsh = { "beautysh" },
			sh = { "beautysh" },
			bash = { "beautysh" },
			markdown = { "prettier" },
			yaml = { "prettier" },
			json = { "prettier" },
			lua = { "stylua" },
			sql = { "sqlfluff" },
		},
		formatters = {
			prettier = {
				append_args = { "--print-width", "80", "--prose-wrap", "always" },
			},
			sqlfluff = {
				append_args = { "--dialect", "sparksql", "--exclude-rules", "CP02" },
				exit_codes = { 0, 1 },
			},
		},
	},
}
