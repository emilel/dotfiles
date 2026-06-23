-- Real-keystroke test for the scratch buffer: <cr><cr> copies it to the
-- clipboard register and closes. (The standalone :Clip/:TempFile variants quit
-- nvim, so only the in-editor path is exercised here.)
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

describe("scratch buffer", function()
	it("copies its contents to the clipboard on <cr><cr>", function()
		fake_clipboard()
		require("lib.scratch").scratch({})
		vim.api.nvim_buf_set_lines(0, 0, -1, false, { "hello", "world" })

		feed("<cr><cr>")
		assert.are.equal("hello\nworld", vim.fn.getreg("+"))
	end)

	it("prefills from opts.content", function()
		require("lib.scratch").scratch({ content = "seed text" })
		assert.are.equal("seed text", vim.api.nvim_buf_get_lines(0, 0, -1, false)[1])
	end)
end)
