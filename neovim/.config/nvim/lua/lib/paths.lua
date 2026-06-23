-- Helpers that describe the current file / git context.
-- Used by the <space>y* "copy metadata" keymaps.
local M = {}

M.get_git_branch = function()
	return vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
end

M.get_relative_path = function()
	return vim.fn.expand("%:~:.")
end

M.get_relative_to_repo_path = function()
	local repo_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	local file_path = vim.fn.expand("%:p")
	local relative_path = file_path:sub(#repo_root + 2)
	return relative_path
end

M.get_absolute_path = function()
	return vim.fn.expand("%:p")
end

M.get_repo_name = function()
	return vim.fn.systemlist("basename `git rev-parse --show-toplevel`")[1]
end

M.get_line = function()
	return vim.fn.line(".")
end

M.get_relative_directory = function()
	local file_directory = vim.fn.expand("%:p:h")
	local cwd = vim.fn.getcwd()
	local relative_directory = file_directory:sub(#cwd + 2) -- +2 to remove the trailing slash
	return relative_directory
end

M.get_absolute_directory = function()
	return vim.fn.expand("%:p:h")
end

-- Tail of a path (the file name). Pure given a path string, so unit-testable.
M.basename = function(path)
	local file_name = ""
	for part in path:gmatch("([^/]+)") do
		file_name = part
	end
	return file_name
end

M.get_file_name = function()
	return M.basename(vim.api.nvim_buf_get_name(0))
end

return M
