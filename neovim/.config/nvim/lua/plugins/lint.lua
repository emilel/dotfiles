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

		local mypy_args = vim.deepcopy(lint.linters.mypy.args) or {}
		lint.linters.mypy.args = vim.list_extend(mypy_args, { "--disallow-untyped-defs", "--disallow-incomplete-defs" })

		-- local venv_dir = vim.fn.getcwd() .. "/.venv"
		-- if vim.fn.isdirectory(venv_dir) == 1 then
		-- 	lint.linters.pylint.cmd = "python"
		-- 	lint.linters.pylint.env = {
		-- 		VIRTUAL_ENV = venv_dir,
		-- 		PATH = venv_dir .. "/bin:" .. vim.env.PATH,
		-- 	}
		-- 	lint.linters.pylint.args = { "-m", "pylint", vim.api.nvim_buf_get_name(0), "-f", "json" }
		-- end

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
