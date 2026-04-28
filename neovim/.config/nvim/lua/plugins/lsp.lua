vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. ":" .. vim.env.PATH

return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
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

		vim.diagnostic.config({ virtual_text = true, float = { source = true } })

		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "Language server protocol",
			callback = function()
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation", buffer = true })
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition", buffer = true })
				vim.keymap.set("n", "<space>H", vim.diagnostic.open_float, { desc = "Open diagnostic" })
				vim.keymap.set("n", "\\r", "<cmd>LspRestart<cr>", { desc = "Restart LSP server", buffer = true })
				vim.keymap.set("n", "\\x", "<cmd>LspStop<cr>", { desc = "Stop LSP server", buffer = true })

				vim.opt_local.formatexpr = "" -- still want to format using vim's rules
			end,
		})
	end,
}
