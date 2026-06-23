-- Scratch-buffer commands. Each one is also driven from the shell (see
-- zsh/.config/zsh/commands): `clip`, `temp` and the `edit` stdin/stdout filter.
local scratch = require("lib.scratch")

-- :TempFile [filetype] -- scratch buffer (markdown by default). `temp` uses it;
-- <cr><cr> copies the buffer to the clipboard and exits nvim.
vim.api.nvim_create_user_command("TempFile", function(opts)
	scratch.scratch({ filetype = opts.args ~= "" and opts.args or "markdown", close = "quit!" })
end, { nargs = "?" })

-- :Clip -- edit the system clipboard; <cr><cr> writes it back and exits nvim.
vim.api.nvim_create_user_command("Clip", function()
	scratch.scratch({ content = vim.fn.getreg("+"), close = "quit!" })
end, {})

-- :Pipe <path> -- edit a file; <cr><cr> saves and quits. The `edit` filter
-- pipes stdin through a temp file and reads it back from stdout.
vim.api.nvim_create_user_command("Pipe", function(opts)
	if vim.loop.fs_stat(opts.args) then
		scratch.pipe(opts.args)
	else
		print("Pipe: no such path: " .. opts.args)
	end
end, { nargs = 1 })
