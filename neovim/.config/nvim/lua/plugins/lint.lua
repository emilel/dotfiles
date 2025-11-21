return {
	"mfussenegger/nvim-lint",
	config = function()
		local linters_by_ft = {
			python = { "mypy", "pylint" },
		}

		local function filter_available_linters(linters)
			local available_linters = {}
			for _, linter in ipairs(linters) do
				if vim.fn.executable(linter) == 1 then
					table.insert(available_linters, linter)
				end
			end
			return available_linters
		end

		for ft, linters in pairs(linters_by_ft) do
			linters_by_ft[ft] = filter_available_linters(linters)
		end

		local lint = require("lint")
		lint.linters_by_ft = linters_by_ft
		lint.linters.pylint.cmd = "python"
		lint.linters.pylint.args = { "-m", "pylint", vim.api.nvim_buf_get_name(0), "-f", "json" }
		lint.linters.pylint.env = {
			VIRTUAL_ENV = vim.fn.getcwd() .. "/.venv",
			PATH = vim.fn.getcwd() .. "/.venv/bin:" .. vim.env.PATH,
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
