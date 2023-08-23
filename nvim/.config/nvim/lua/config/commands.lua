vim.api.nvim_create_user_command('SetReg', function(arg)
	require("config.functions").setreg(arg.fargs[1], arg.fargs[2])
end, { nargs = '*' })

vim.api.nvim_create_user_command('Lang', function(arg)
	if arg.fargs[1] == 'swe' then
		vim.opt_local.spelllang = 'sv'
	elseif arg.fargs[1] == 'eng' then
		vim.opt_local.spelllang = 'en_us'
	end
end, { nargs = 1 })

vim.api.nvim_create_user_command('Log', function()
	vim.cmd([[set autoread | au CursorHold * checktime | call feedkeys("G")]])
	vim.keymap.set('n', '<space>S', '<cmd>set eventignore=all<cr>', { desc = 'Pause following log' })
	vim.keymap.set('n', '<space>L', ':set eventignore=""<cr>', { desc = 'Start following log' })
end, {})

vim.api.nvim_create_user_command('Temp', function(arg)
	local filetype = arg.fargs[1] or "markdown"
	vim.cmd([[execute "edit " . system("mktemp") | set buftype=nofile | set filetype=]] .. filetype)
	vim.keymap.set('n', '<c-space>', ':echo "better create a file if you want to save dude..."<cr>', {buffer = true})
	vim.keymap.set('n', '<cr><cr>', 'gg0vG$y:bd<cr>', { buffer = true })
end, { nargs = '*' })
