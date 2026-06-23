-- Real-keystroke tests for a few editing keymaps with non-obvious behaviour.
local function feed(keys)
	local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(termcodes, "mx", false)
end

local function line(n)
	return vim.api.nvim_buf_get_lines(0, n - 1, n, false)[1]
end

describe("editing keymaps", function()
	before_each(function()
		vim.cmd("enew!")
	end)

	it("<space>J joins the next line with NO space, trimming whitespace", function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "foo", "   bar" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })

		feed("<space>J")
		assert.are.equal("foobar", line(1))
	end)

	it("x deletes a char without clobbering the unnamed register", function()
		vim.fn.setreg('"', "KEEP")
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "abc" })
		vim.api.nvim_win_set_cursor(0, { 1, 1 }) -- on 'b'

		feed("x")
		assert.are.equal("ac", line(1))
		assert.are.equal("KEEP", vim.fn.getreg('"'))
	end)
end)

describe("search keymaps", function()
	before_each(function()
		vim.cmd("enew!")
	end)

	it("* sets the search register with word boundaries and does not jump", function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "foo bar", "baz foo" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 }) -- on first 'foo'

		feed("*")
		assert.are.equal("\\<foo\\>", vim.fn.getreg("/"))
		assert.are.equal(1, vim.api.nvim_win_get_cursor(0)[1]) -- stayed put
	end)
end)
