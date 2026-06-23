-- Real-keystroke tests for the yank / copy keymaps whose behaviour is
-- non-obvious (skipping leading whitespace, fenced-block wrapping, etc.).
local function feed(keys)
	local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(termcodes, "mx", false)
end

-- Headless nvim has no system clipboard; register an in-memory provider so the
-- + register actually round-trips.
local function fake_clipboard()
	local store = { {}, "v" }
	vim.g.clipboard = {
		name = "memory",
		copy = {
			["+"] = function(lines, regtype)
				store = { lines, regtype }
			end,
			["*"] = function(lines, regtype)
				store = { lines, regtype }
			end,
		},
		paste = {
			["+"] = function()
				return store[1], store[2]
			end,
			["*"] = function()
				return store[1], store[2]
			end,
		},
	}
end

describe("yank keymaps", function()
	before_each(function()
		vim.cmd("enew!")
	end)

	it("visual y keeps cursor at the position where y was pressed (not the selection start)", function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "hello world" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 }) -- on 'h' (col 0)

		-- 'v4l' selects cols 0-4 ("hello"); cursor is at col 4 when y is pressed.
		-- Without the remap, Vim's built-in y moves cursor to col 0 (selection start).
		-- With 'ygv<esc>', gv re-enters visual at col 4 and <esc> keeps it there.
		feed("v4l")
		feed("y")
		assert.are.equal(4, vim.api.nvim_win_get_cursor(0)[2])
		assert.are.equal("hello", vim.fn.getreg('"'))
	end)

	it("<space>yy copies line content (no leading whitespace) to the unnamed register", function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "    hello world" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 }) -- at column 0

		feed("<space>yy")
		-- ^y$ starts from the first non-blank, so leading spaces are excluded
		assert.are.equal("hello world", vim.fn.getreg('"'))
		-- cursor returns to its original position
		assert.are.equal(0, vim.api.nvim_win_get_cursor(0)[2])
	end)

	it("visual <space>y wraps the selection as a fenced code block into the + register", function()
		fake_clipboard()
		vim.bo.filetype = "python"
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "print('hello')" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })

		feed("V<space>y") -- linewise select then wrap
		assert.are.equal("```python\nprint('hello')\n```", vim.fn.getreg("+"))
	end)

	it("visual Y appends the linewise selection to the existing clipboard content", function()
		fake_clipboard()
		vim.fn.setreg("+", "first\n")
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "second" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })

		feed("VY") -- linewise select then append
		-- linewise branch: concatenates the yanked line (with its newline) onto clipboard
		assert.are.equal("first\nsecond\n", vim.fn.getreg("+"))
	end)

	it("<space>+ opens a scratch buffer prefilled with the current clipboard content", function()
		fake_clipboard()
		vim.fn.setreg("+", "clipboard seed")

		feed("<space>+")

		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		assert.are.equal("clipboard seed", lines[1])
		vim.cmd("bdelete!")
	end)
end)
