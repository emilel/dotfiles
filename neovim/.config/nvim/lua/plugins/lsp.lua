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

		-- basedpyright resolves imports against whatever interpreter it is
		-- launched with -- which, in a monorepo with several venvs, is the
		-- wrong one (the shell's active $VIRTUAL_ENV shadows the project's own
		-- .venv). Root the server at the nearest .venv to the file and point
		-- its interpreter there, so each subproject gets its own packages.
		vim.lsp.config("basedpyright", {
			root_dir = function(bufnr, on_dir)
				local fname = vim.api.nvim_buf_get_name(bufnr)
				local venv = vim.fs.find(".venv", {
					path = vim.fs.dirname(fname),
					upward = true,
					type = "directory",
				})[1]
				on_dir(
					venv and vim.fs.dirname(venv)
						or vim.fs.root(fname, { "pyproject.toml", "setup.py", ".git" })
				)
			end,
			before_init = function(_, config)
				local python = config.root_dir and (config.root_dir .. "/.venv/bin/python")
				if python and vim.fn.executable(python) == 1 then
					config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
						python = { pythonPath = python },
					})
				end
			end,
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
