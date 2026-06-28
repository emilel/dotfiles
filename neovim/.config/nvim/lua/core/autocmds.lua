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

-- un-scroll after auto hard-wrap: with nowrap and the text area exactly as
-- wide as textwidth (e.g. an 80-col file in an 80-col split), typing the
-- character that triggers the textwidth break pushes the cursor one column
-- past the edge, which leaves the view stuck scrolled one char right. Pin it
-- back to column 0 whenever the line under the cursor fits in the window.
local unscroll = vim.api.nvim_create_augroup("unscroll_on_wrap", { clear = true })
vim.api.nvim_create_autocmd({ "TextChangedI", "InsertLeave", "TextChanged" }, {
	group = unscroll,
	callback = function()
		if vim.wo.wrap then
			return
		end
		local view = vim.fn.winsaveview()
		if view.leftcol == 0 then
			return
		end
		local avail = vim.fn.winwidth(0) - vim.fn.getwininfo(vim.fn.win_getid())[1].textoff
		if vim.fn.virtcol(".") <= avail then
			view.leftcol = 0
			vim.fn.winrestview(view)
		end
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
