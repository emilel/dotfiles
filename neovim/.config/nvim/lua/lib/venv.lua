-- Point Python tooling at the project's virtualenv with no per-project config.
-- LSP servers (pyright/basedpyright), ruff, mypy, pylint and :!python all honour
-- $VIRTUAL_ENV / $PATH, so exporting the nearest .venv is all that's needed.
local M = {}

function M.activate()
	local venv = vim.fs.find({ ".venv", "venv" }, {
		upward = true,
		type = "directory",
		path = vim.fn.getcwd(),
	})[1]
	if not venv then
		return
	end
	vim.env.VIRTUAL_ENV = venv
	vim.env.PATH = venv .. "/bin:" .. vim.env.PATH
end

return M
