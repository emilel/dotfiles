return {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
			callback = function(args)
				if vim.bo[args.buf].filetype ~= "python" then
					return
				end
				local file = vim.api.nvim_buf_get_name(args.buf)
				if file == "" or file:match("/tests/") then
					return
				end

				-- Import-aware linters must run from the project's *own* venv,
				-- or they report false import errors against their isolated
				-- (Mason) environment. In a monorepo with several venvs, resolve
				-- the nearest .venv to this file and enable only the linters
				-- actually installed there.
				local venv = vim.fs.find(".venv", {
					path = vim.fs.dirname(file),
					upward = true,
					type = "directory",
				})[1]
				if not venv then
					return
				end

				local enabled = {}
				for _, name in ipairs({ "ruff", "mypy", "pylint" }) do
					local bin = venv .. "/bin/" .. name
					if vim.fn.executable(bin) == 1 then
						lint.linters[name].cmd = bin
						table.insert(enabled, name)
					end
				end
				if #enabled > 0 then
					lint.try_lint(enabled)
				end
			end,
		})
	end,
	lazy = false,
}
