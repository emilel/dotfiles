-- Tests for indent-aware jump keymaps (<space>i / <space>I).
-- The algorithm is non-obvious: it skips blank lines and stops only at lines
-- that share the exact same indentation depth. Regressions here would be silent.
local function feed(keys)
	local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(termcodes, "mx", false)
end

local function cursor()
	return vim.api.nvim_win_get_cursor(0)
end

describe("navigation keymaps", function()
	before_each(function()
		vim.cmd("enew!")
	end)

	describe("<space>i jumps forward to the next same-indent line", function()
		it("lands on the next line at the same indentation level", function()
			vim.api.nvim_buf_set_lines(0, 0, -1, false, {
				"def foo():", -- line 1, indent 0
				"    pass", -- line 2, indent 4
				"def bar():", -- line 3, indent 0
			})
			vim.api.nvim_win_set_cursor(0, { 1, 0 })
			feed("<space>i")
			assert.are.equal(3, cursor()[1])
		end)

		it("skips blank lines", function()
			vim.api.nvim_buf_set_lines(0, 0, -1, false, {
				"a", -- line 1, indent 0
				"", -- line 2, blank
				"b", -- line 3, indent 0
			})
			vim.api.nvim_win_set_cursor(0, { 1, 0 })
			feed("<space>i")
			assert.are.equal(3, cursor()[1])
		end)

		it("does not move when there is no same-indent line below", function()
			vim.api.nvim_buf_set_lines(0, 0, -1, false, {
				"only line",
			})
			vim.api.nvim_win_set_cursor(0, { 1, 0 })
			feed("<space>i")
			assert.are.equal(1, cursor()[1])
		end)

		it("skips deeper-indented lines, landing on the next peer", function()
			vim.api.nvim_buf_set_lines(0, 0, -1, false, {
				"    a = 1", -- line 1, indent 4
				"        nested", -- line 2, indent 8 — must be skipped
				"    b = 2", -- line 3, indent 4
			})
			vim.api.nvim_win_set_cursor(0, { 1, 4 })
			feed("<space>i")
			assert.are.equal(3, cursor()[1])
		end)

		it("positions the cursor column at the indentation depth", function()
			vim.api.nvim_buf_set_lines(0, 0, -1, false, {
				"    first", -- line 1, indent 4
				"        nested", -- line 2, indent 8
				"    second", -- line 3, indent 4
			})
			vim.api.nvim_win_set_cursor(0, { 1, 4 })
			feed("<space>i")
			assert.are.equal(3, cursor()[1])
			assert.are.equal(4, cursor()[2]) -- column = indent width
		end)
	end)

	describe("<space>I jumps backward to the previous same-indent line", function()
		it("lands on the previous line at the same indentation level", function()
			vim.api.nvim_buf_set_lines(0, 0, -1, false, {
				"def foo():", -- line 1, indent 0
				"    pass", -- line 2, indent 4
				"def bar():", -- line 3, indent 0
			})
			vim.api.nvim_win_set_cursor(0, { 3, 0 })
			feed("<space>I")
			assert.are.equal(1, cursor()[1])
		end)

		it("skips blank lines going backward", function()
			vim.api.nvim_buf_set_lines(0, 0, -1, false, {
				"a", -- line 1, indent 0
				"", -- line 2, blank
				"b", -- line 3, indent 0
			})
			vim.api.nvim_win_set_cursor(0, { 3, 0 })
			feed("<space>I")
			assert.are.equal(1, cursor()[1])
		end)

		it("does not move when there is no same-indent line above", function()
			vim.api.nvim_buf_set_lines(0, 0, -1, false, {
				"only line",
			})
			vim.api.nvim_win_set_cursor(0, { 1, 0 })
			feed("<space>I")
			assert.are.equal(1, cursor()[1])
		end)

		it("skips shallower-indented lines, landing on the previous peer", function()
			vim.api.nvim_buf_set_lines(0, 0, -1, false, {
				"    a = 1", -- line 1, indent 4
				"        nested", -- line 2, indent 8
				"    b = 2", -- line 3, indent 4
			})
			vim.api.nvim_win_set_cursor(0, { 3, 4 })
			feed("<space>I")
			assert.are.equal(1, cursor()[1])
		end)
	end)
end)
