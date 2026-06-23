-- Real-keystroke tests for `gp` ("select the text I just touched"). These drive
-- the actual keymap through feedkeys, so they catch regressions in behaviour
-- (not just in pure helpers).
local function feed(keys)
	local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(termcodes, "mx", false) -- m = remap, x = flush now
end

-- Yank the currently-active visual selection without going through any `y`
-- remaps, so the assertion observes exactly what `gp` selected.
local function selection()
	vim.cmd('normal! "zy')
	return vim.fn.getreg("z")
end

describe("gp selects pasted/inserted text", function()
	before_each(function()
		vim.cmd("enew!")
	end)

	it("selects charwise-pasted text", function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "hello world" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })
		vim.fn.setreg('"', "XYZ", "c")

		feed("p") -- hXYZello world
		feed("gp") -- select the pasted span
		assert.are.equal("XYZ", selection())
	end)

	it("selects linewise-pasted text", function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "first", "last" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })
		vim.fn.setreg('"', "middle\n", "l")

		feed("p") -- first / middle / last
		feed("gp")
		assert.are.equal("middle", selection())
	end)

	it("selects text inserted in insert mode", function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
		vim.api.nvim_win_set_cursor(0, { 1, 0 })

		feed("iabc<esc>") -- insert abc; `[ `] mark the inserted span
		feed("gp")
		assert.are.equal("abc", selection())
	end)
end)
