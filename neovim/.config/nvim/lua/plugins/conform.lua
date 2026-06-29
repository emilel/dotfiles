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
			sh = { "shfmt" },
			bash = { "shfmt" },
			markdown = { "dprint" },
			yaml = { "prettier" },
			json = { "prettier" },
			lua = { "stylua" },
			sql = { "sqlfluff" },
		},
		formatters = {
			prettier = {
				append_args = { "--print-width", "80", "--prose-wrap", "always" },
			},
			-- match tests/lint.sh so editor-save and repo-lint never disagree
			shfmt = {
				prepend_args = { "-i", "4", "-ci" },
			},
			-- markdown at 80 cols, no node dependency (config: ~/.config/dprint)
			dprint = {
				prepend_args = { "--config", vim.fn.expand("~/.config/dprint/dprint.json") },
			},
			sqlfluff = {
				append_args = { "--dialect", "sparksql", "--exclude-rules", "CP02" },
				exit_codes = { 0, 1 },
			},
		},
	},
}
