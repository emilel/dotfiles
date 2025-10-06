-- show number column
vim.opt.number = true

-- show sign column
vim.opt.signcolumn = "yes:1"

-- use spaces instead of tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- don't hide characters
vim.opt.conceallevel = 0

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ timeout = 500 })
	end,
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
})

-- show whitespace in normal mode
local whitespace_group = vim.api.nvim_create_augroup("visible_whitespace", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
	group = whitespace_group,
	callback = function()
		vim.opt_local.list = false
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	group = whitespace_group,
	callback = function()
		vim.opt_local.list = true
	end,
})

-- show cursor line
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "cursorlinenr", { fg = "yellow", bold = true })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
local cursorline = vim.api.nvim_create_augroup("cursorline", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained" }, {
	group = cursorline,
	callback = function()
		vim.opt.cursorline = true
	end,
})
vim.api.nvim_create_autocmd({ "FocusLost" }, {
	group = cursorline,
	callback = function()
		vim.opt.cursorline = false
	end,
})
