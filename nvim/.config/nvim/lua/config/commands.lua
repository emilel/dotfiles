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
