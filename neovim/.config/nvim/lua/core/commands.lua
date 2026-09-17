-- Scratch-buffer commands. Each one is also driven from the shell (see
-- zsh/.config/zsh/commands): `temp`, and the `edit` / `clip` filters.
local scratch = require("lib.scratch")

-- :TempFile [filetype] -- scratch buffer (markdown by default). `temp` uses it;
-- <cr><cr> copies the buffer to the clipboard and exits nvim.
vim.api.nvim_create_user_command("TempFile", function(opts)
	scratch.scratch({ filetype = opts.args ~= "" and opts.args or "markdown", close = "quit!" })
end, { nargs = "?" })

-- :Pipe <path> -- edit a file; <cr><cr> saves and quits, :cq abandons it.
-- `edit` (and `clip`, which is the clipboard piped through `edit`) drives
-- stdin through a temp file and reads it back on exit.
vim.api.nvim_create_user_command("Pipe", function(opts)
	if vim.loop.fs_stat(opts.args) then
		scratch.pipe(opts.args)
	else
		print("Pipe: no such path: " .. opts.args)
	end
end, { nargs = 1 })
