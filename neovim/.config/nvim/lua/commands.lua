local yank = require("functions.yank")

vim.api.nvim_create_user_command("TempFile", function(opts)
	yank.open_buffer()
	yank.set_exit_keymap("q!")

	if opts.args and opts.args ~= "" then
		vim.bo.filetype = opts.args
	else
		vim.bo.filetype = "markdown"
	end
end, { nargs = "?" })

vim.api.nvim_create_user_command("Clip", function()
	yank.open_buffer()
	yank.set_exit_keymap("q!")
	vim.api.nvim_feedkeys("P", "n", false)
end, { nargs = "*" })

vim.api.nvim_create_user_command("Pipe", function(opts)
	local path = opts.args

	if vim.loop.fs_stat(path) then
		vim.cmd("edit " .. vim.fn.fnameescape(path))
		yank.set_exit_keymap("wq!")
	else
		print("Error: Path does not exist: " .. path)
	end
end, { nargs = 1 })

vim.api.nvim_create_user_command("Temp", function()
	yank.open_buffer()
	yank.set_exit_keymap("bd!")
end, { nargs = "*" })
