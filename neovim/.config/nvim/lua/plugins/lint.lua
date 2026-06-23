return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Only keep linters that are actually installed (e.g. present in the venv).
		local function available(linters)
			return vim.tbl_filter(function(l)
				return vim.fn.executable(l) == 1
			end, linters)
		end

		lint.linters_by_ft = {
			python = available({ "mypy", "pylint" }),
		}

		local function try_lint()
			if not vim.api.nvim_buf_get_name(0):match("/tests/") then
				lint.try_lint()
			end
		end

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, { callback = try_lint })
		try_lint() -- lint the buffer that triggered loading
	end,
}
