-- A list item's continuation hangs under its text. That is Vim's own `fo+=n`
-- with the markdown ftplugin's 'formatlistpat', and it only works while
-- 'indentexpr' is empty -- plugins/treesitter.lua keeps it that way for
-- markdown, which this plugin-free harness can't load.
local function feed(keys)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "xt", false)
end

describe("markdown lists", function()
	before_each(function()
		vim.cmd("filetype plugin on")
		vim.cmd("enew!")
		require("core.options")
		vim.bo.filetype = "markdown"
	end)

	it("auto-wrap at 'textwidth' hangs the wrapped line", function()
		vim.bo.textwidth = 20
		feed("i- aaaa bbbb cccc dddd eeee<Esc>")
		assert.are.same({ "- aaaa bbbb cccc", "  dddd eeee" }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
	end)

	it("gq hangs a long list item the same way", function()
		vim.bo.textwidth = 20
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "- aaaa bbbb cccc dddd eeee" })
		feed("gqq")
		assert.are.same({ "- aaaa bbbb cccc", "  dddd eeee" }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
	end)
end)
