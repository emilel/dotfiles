-- User commands for spinning up scratch buffers (formerly lua/commands.lua).
local scratch = require("lib.scratch")

-- :TempFile [filetype] -- empty scratch buffer (defaults to markdown).
vim.api.nvim_create_user_command("TempFile", function(opts)
	scratch.open_buffer()
	scratch.set_exit_keymap("q!")
	vim.bo.filetype = (opts.args and opts.args ~= "") and opts.args or "markdown"
end, { nargs = "?" })

-- :Clip -- scratch buffer pre-filled with the clipboard.
vim.api.nvim_create_user_command("Clip", function()
	scratch.open_buffer()
	scratch.set_exit_keymap("q!")
	vim.api.nvim_feedkeys("P", "n", false)
end, { nargs = "*" })

-- :Pipe <path> -- edit an existing file, copy-and-save-quit on <cr><cr>.
vim.api.nvim_create_user_command("Pipe", function(opts)
	local path = opts.args
	if vim.loop.fs_stat(path) then
		vim.cmd("edit " .. vim.fn.fnameescape(path))
		scratch.set_exit_keymap("wq!")
	else
		print("Error: Path does not exist: " .. path)
	end
end, { nargs = 1 })

-- :Temp -- empty scratch buffer, copy-and-delete on <cr><cr>.
vim.api.nvim_create_user_command("Temp", function()
	scratch.open_buffer()
	scratch.set_exit_keymap("bd!")
end, { nargs = "*" })
