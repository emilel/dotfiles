-- LSP: load on first real buffer. Each piece is a separate, swappable dependency:
--   mason            -> installs servers
--   nvim-lspconfig   -> ships the per-server default configs
--   blink.cmp        -> provides completion capabilities
-- mason-lspconfig (v2) auto-enables every installed server via vim.lsp.enable().
return {
	"williamboman/mason-lspconfig.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
		"saghen/blink.cmp",
	},
	config = function()
		-- Defaults applied to every server, then auto-enable installed ones.
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		})
		require("mason-lspconfig").setup()

		vim.diagnostic.config({ virtual_text = true, float = { source = true } })

		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP buffer keymaps",
			callback = function(args)
				local function map(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
				end
				map("K", vim.lsp.buf.hover, "Hover documentation")
				map("gd", vim.lsp.buf.definition, "Go to definition")
				map("<space>H", vim.diagnostic.open_float, "Open diagnostic")
				map("\\r", "<cmd>LspRestart<cr>", "Restart LSP server")
				map("\\x", "<cmd>LspStop<cr>", "Stop LSP server")
				vim.opt_local.formatexpr = "" -- keep gq using vim's own formatting
			end,
		})
	end,
}
