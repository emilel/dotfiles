return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Import-aware linters must run from the project's *own* venv, or they
		-- report false import errors against their isolated (Mason) environment.
		-- In a monorepo with several venvs, resolve the nearest .venv to the file
		-- and run only the linters actually installed there. (ruff is handled by
		-- its LSP server -- see plugins/lsp.lua -- so only mypy and pylint here.)
		local function lint_buffer(buf)
			if vim.bo[buf].filetype ~= "python" then
				return
			end
			local file = vim.api.nvim_buf_get_name(buf)
			if file == "" or file:match("/tests/") then
				return
			end

			local venv = vim.fs.find(".venv", {
				path = vim.fs.dirname(file),
				upward = true,
				type = "directory",
			})[1]
			if not venv then
				return
			end

			local enabled = {}
			for _, name in ipairs({ "mypy", "pylint" }) do
				local bin = venv .. "/bin/" .. name
				if vim.fn.executable(bin) == 1 then
					lint.linters[name].cmd = bin
					table.insert(enabled, name)
				end
			end
			if #enabled > 0 then
				lint.try_lint(enabled)
			end
		end

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
			callback = function(args)
				lint_buffer(args.buf)
			end,
		})
		lint_buffer(0) -- lint the buffer that triggered loading
	end,
}
