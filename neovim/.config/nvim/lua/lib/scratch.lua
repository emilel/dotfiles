-- Temporary "scratch" buffers backed by a mktemp file.
-- Used by <space>b, the :TempFile/:Clip/:Temp commands and python's <space>N.
local M = {}

M.open_buffer = function()
	local filename = vim.fn.system("mktemp")
	vim.diagnostic.config({ virtual_text = false })
	vim.opt_local.signcolumn = "no"
	vim.api.nvim_command("edit " .. vim.fn.trim(filename))
end

-- Bind <cr><cr> (buffer-local) to copy the whole buffer to the system
-- clipboard and then run `command` (e.g. "bdelete!", "q!", "wq!").
M.set_exit_keymap = function(command)
	vim.keymap.set("n", "<cr><cr>", function()
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		local content = table.concat(lines, "\n")
		vim.fn.setreg("+", content)
		vim.cmd(command)
	end, { buffer = true, desc = "Copy content and close buffer" })
end

return M
