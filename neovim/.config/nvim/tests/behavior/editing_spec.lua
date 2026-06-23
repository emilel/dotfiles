-- Real-keystroke tests for editing keymaps with non-obvious behaviour.
local function feed(keys)
	local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(termcodes, "mx", false)
end

local function line(n)
	return vim.api.nvim_buf_get_lines(0, n - 1, n, false)[1]
end

local function cursor()
	return vim.api.nvim_win_get_cursor(0)
end

describe("editing keymaps", function()
	before_each(function()
		vim.cmd("enew!")
	end)

	it("<space>J joins the next line with NO space, trimming leading whitespace", function()
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

	it("<space>d deletes without clobbering the unnamed register", function()
		vim.fn.setreg('"', "KEEP")
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "hello world" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })

		feed("<space>dw") -- delete 'hello ' to black-hole register
		assert.are.equal("world", line(1))
		assert.are.equal("KEEP", vim.fn.getreg('"'))
	end)

	it("<space>o adds a blank line below without moving the cursor", function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "foo", "bar" })
		vim.api.nvim_win_set_cursor(0, { 1, 1 }) -- on 'o' in 'foo'

		feed("<space>o")
		assert.are.equal(3, vim.api.nvim_buf_line_count(0))
		assert.are.equal("", line(2))
		assert.are.equal(1, cursor()[1]) -- stayed on line 1
		assert.are.equal(1, cursor()[2]) -- stayed on same column
	end)

	it("<space>O adds a blank line above without moving the cursor", function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "foo", "bar" })
		vim.api.nvim_win_set_cursor(0, { 2, 0 }) -- on 'bar'

		feed("<space>O")
		assert.are.equal(3, vim.api.nvim_buf_line_count(0))
		assert.are.equal("", line(2))
		-- cursor follows original content: 'bar' is now on line 3
		assert.are.equal(3, cursor()[1])
		assert.are.equal(0, cursor()[2])
	end)

	it("visual <space>J joins two selected lines with no space", function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "foo", "  bar", "baz" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })

		feed("Vj<space>J") -- select lines 1-2 then join
		assert.are.equal("foobar", line(1))
		assert.are.equal("baz", line(2))
	end)

	it("X deletes a char and copies it to the unnamed register", function()
		vim.fn.setreg('"', "OLD")
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "abc" })
		vim.api.nvim_win_set_cursor(0, { 1, 1 }) -- on 'b'

		feed("X") -- remapped to plain 'x': delete and yank
		assert.are.equal("ac", line(1))
		assert.are.equal("b", vim.fn.getreg('"')) -- clobbered (intentional)
	end)

	it("s substitutes a char without clobbering the unnamed register", function()
		vim.fn.setreg('"', "KEEP")
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "abc" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 }) -- on 'a'

		feed("sz<esc>") -- substitute 'a' with 'z'
		assert.are.equal("zbc", line(1))
		assert.are.equal("KEEP", vim.fn.getreg('"'))
	end)

	it("<space>c changes without clobbering the unnamed register", function()
		vim.fn.setreg('"', "KEEP")
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "hello world" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })

		feed("<space>cwbye<esc>") -- change word to 'bye'
		assert.are.equal("bye world", line(1))
		assert.are.equal("KEEP", vim.fn.getreg('"'))
	end)

	it("visual <space>d deletes selection without clobbering the unnamed register", function()
		vim.fn.setreg('"', "KEEP")
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "hello world" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })

		feed("ve<space>d") -- select 'hello' then delete to black hole
		assert.are.equal(" world", line(1))
		assert.are.equal("KEEP", vim.fn.getreg('"'))
	end)

	it("visual D copies the selected text to unnamed and deletes the whole line", function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "hello world", "second" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })

		feed("veD") -- select 'hello', then D: copy 'hello', delete whole line
		assert.are.equal("hello", vim.fn.getreg('"'))
		assert.are.equal("second", line(1))
		assert.are.equal(1, vim.api.nvim_buf_line_count(0))
	end)

	it("visual > keeps selection so a second > indents again", function()
		vim.bo.shiftwidth = 2
		vim.bo.expandtab = true
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "foo", "bar" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })

		-- Each > is remapped to '>gv' (indent + reselect), so two presses = 2 levels.
		feed("Vj>>")
		feed("<esc>")
		assert.are.equal("    foo", line(1))
		assert.are.equal("    bar", line(2))
	end)

	it("visual < keeps selection so a second < de-indents again", function()
		vim.bo.shiftwidth = 2
		vim.bo.expandtab = true
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "    foo", "    bar" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })

		feed("Vj<<")
		feed("<esc>")
		assert.are.equal("foo", line(1))
		assert.are.equal("bar", line(2))
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
		assert.are.equal(1, cursor()[1]) -- stayed put
	end)

	it("<space><space>* appends the current word to the existing search", function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "foo bar" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 }) -- on 'foo'
		vim.fn.setreg("/", "\\<existing\\>")

		feed("<space><space>*")
		assert.are.equal("\\<existing\\>\\|\\<foo\\>", vim.fn.getreg("/"))
	end)

	it("visual * sets the search to the selected text without jumping", function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "hello world", "hello again" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })

		feed("viw") -- select 'hello' (inner word)
		feed("*")

		assert.are.equal("hello", vim.fn.getreg("/"))
		assert.are.equal(1, vim.api.nvim_win_get_cursor(0)[1]) -- no jump to line 2
	end)

	it("visual <space>/ appends the selected text to the current search", function()
		vim.fn.setreg("/", "existing")
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "hello world" })
		vim.api.nvim_win_set_cursor(0, { 1, 6 }) -- on 'w' of 'world'

		feed("viw") -- select 'world'
		feed("<space>/")

		assert.are.equal("existing\\|world", vim.fn.getreg("/"))
	end)
end)
