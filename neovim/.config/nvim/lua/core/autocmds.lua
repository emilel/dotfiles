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

-- images and videos go to the desktop viewer (mimeapps: swayimg, mpv) instead
-- of a buffer full of binary. BufReadCmd catches every way in: nnn's <cr>,
-- telescope, :e. svg is left alone, it's text worth editing.
local media = { "png", "jpg", "jpeg", "gif", "webp", "bmp", "tif", "tiff", "avif", "heic", "jxl" }
vim.list_extend(media, { "mp4", "m4v", "mkv", "webm", "mov", "avi", "mpg", "mpeg", "ogv" })
local media_patterns = {}
for _, ext in ipairs(media) do
	-- cameras shout: IMG_0001.JPG
	vim.list_extend(media_patterns, { "*." .. ext, "*." .. ext:upper() })
end
vim.api.nvim_create_autocmd("BufReadCmd", {
	group = vim.api.nvim_create_augroup("open_media_externally", { clear = true }),
	pattern = media_patterns,
	callback = function(args)
		local _, err = vim.ui.open(args.match)
		if err then
			vim.notify(err, vim.log.levels.ERROR)
		end
		-- deleting the buffer mid-:edit upsets nvim, so do it once it's done
		vim.schedule(function()
			local alt = vim.fn.bufnr("#")
			if vim.api.nvim_get_current_buf() == args.buf and alt > 0 and alt ~= args.buf then
				vim.api.nvim_win_set_buf(0, alt)
			end
			if vim.api.nvim_buf_is_valid(args.buf) then
				vim.api.nvim_buf_delete(args.buf, { force = true })
			end
		end)
	end,
})
