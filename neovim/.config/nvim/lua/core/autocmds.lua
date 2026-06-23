-- Autocommands and one-off highlight tweaks (formerly in settings/visual.lua).

-- briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 500 })
	end,
})

-- show whitespace (listchars) only outside of insert mode
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

-- cursor line: bright number, only while the window is focused
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
