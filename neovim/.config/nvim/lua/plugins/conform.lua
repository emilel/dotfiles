vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. ":" .. vim.env.PATH

return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				python = { "ruff_format", "isort" },
				zsh = { "beautysh" },
				sh = { "beautysh" },
				bash = { "beautysh" },
				markdown = { "prettier" },
				lua = { "stylua" },
			},
			formatters = {
				prettier = {
					append_args = { "--print-width", "80", "--prose-wrap", "always" },
				},
			},
		})
	end,
}
