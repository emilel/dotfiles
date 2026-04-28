return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
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
		})
		vim.keymap.set({ "n", "x" }, "<space>z", function()
			require("conform").format({ lsp_fallback = true })
		end, { desc = "Format buffer" })
	end,
	lazy = false,
}
