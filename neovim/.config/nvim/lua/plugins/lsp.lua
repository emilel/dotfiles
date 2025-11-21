vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. ":" .. vim.env.PATH

return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
		"stevearc/conform.nvim",
	},
	config = function()
		require("mason").setup()

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
			},
		})

		require("conform").setup({
			formatters_by_ft = {
				python = { "ruff_format", "ruff_organize_imports" },
				zsh = { "beautysh" },
				sh = { "beautysh" },
				bash = { "beautysh" },
				markdown = { "prettier" },
				json = { "prettier" },
				lua = { "stylua" },
			},
			formatters = {
				prettier = {
					append_args = { "--print-width", "80", "--prose-wrap", "always" },
				},
			},
		})

		vim.diagnostic.config({ virtual_text = true })

		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "Language server protocol",
			callback = function()
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation", buffer = true })
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition", buffer = true })
				vim.keymap.set("n", "\\f", vim.diagnostic.open_float, { desc = "Open diagnostic" })
				vim.keymap.set({ "n", "x" }, "\\z", function()
					require("conform").format({ lsp_fallback = true })
				end, { desc = "Format buffer" })
				vim.keymap.set("n", "\\r", "<cmd>LspRestart<cr>", { desc = "Restart LSP server" })
				vim.keymap.set("n", "\\x", "<cmd>LspStop<cr>", { desc = "Stop LSP server" })
			end,
		})
	end,
}
