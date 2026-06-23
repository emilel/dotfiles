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
		-- Defaults for every server: blink's completion capabilities.
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
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

		-- Auto-enable every installed server (inherits the configs above).
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
