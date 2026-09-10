-- `+` / `-` grow and shrink the selection by syntax node. Neovim 0.13 provides
-- the `an` / `in` visual-mode operators these remap onto, so this needs no
-- plugin -- only a lua parser, which ships with Neovim.
local function feed(keys)
	local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(termcodes, "mx", false)
end

-- The selection as { start_line, start_col, end_line, end_col }. Columns matter:
-- the outermost two nodes here differ only by the trailing newline.
local function selection()
	local a = { vim.fn.line("v"), vim.fn.col("v") }
	local b = { vim.fn.line("."), vim.fn.col(".") }
	if a[1] > b[1] or (a[1] == b[1] and a[2] > b[2]) then
		a, b = b, a
	end
	return { a[1], a[2], b[1], b[2] }
end

-- Just the lines, for the assertions that don't care where in them it stops.
local function lines(sel)
	return { sel[1], sel[3] }
end

describe("node selection", function()
	before_each(function()
		vim.cmd("enew!")
		vim.bo.filetype = "lua"
		vim.api.nvim_buf_set_lines(0, 0, -1, false, {
			"local function f(a, b)",
			"\treturn a + b",
			"end",
		})
		vim.treesitter.start(0, "lua")
	end)

	after_each(function()
		feed("<esc>")
	end)

	it("+ opens a visual selection on the node under the cursor", function()
		vim.fn.cursor(2, 9)
		feed("+")
		assert.are.same("v", vim.fn.mode())
		assert.are.same({ 2, 9, 2, 13 }, selection()) -- the `a + b` operand under the cursor
	end)

	-- `a` -> `a + b` -> `return a + b` are all on one line, so the count is a
	-- property of the tree, not of the keymap: press until it stops growing.
	it("+ climbs to the whole function, one node at a time", function()
		vim.fn.cursor(2, 9)
		feed("+")
		local steps = { selection() }
		for _ = 1, 10 do
			feed("+")
			steps[#steps + 1] = selection()
		end
		assert.are.same({ 1, 3 }, lines(steps[#steps]))
		-- monotonic: a press never shrinks the selection
		for i = 2, #steps do
			assert.is_true(steps[i][1] <= steps[i - 1][1])
			assert.is_true(steps[i][3] >= steps[i - 1][3])
		end
	end)

	it("- shrinks a grown selection back down", function()
		vim.fn.cursor(2, 9)
		feed("+")
		for _ = 1, 10 do
			feed("+")
		end
		local grown = selection()
		assert.are.same({ 1, 3 }, lines(grown))
		-- Back down the same ladder, a node at a time, until it is inside line 2 again.
		for _ = 1, 3 do
			feed("-")
		end
		assert.are.same({ 2, 2 }, lines(selection()))
	end)
end)
