-- Moving around: horizontal scroll, folds, indentation-aware jumps.

-- horizontal scroll
vim.keymap.set("n", "H", "zH", { desc = "Scroll to the left" })
vim.keymap.set("n", "L", "zL", { desc = "Scroll to the right" })

-- Toggle the fold under the cursor. Several folds can start on the same line --
-- a python `def` whose signature wraps opens both a `function_definition` and a
-- `parameters` fold on the `def` line -- and plain `za` would close only the
-- innermost, folding the signature and leaving the body. So keep closing while
-- the folds still start on the cursor line, and open recursively to undo that.
local function toggle_fold()
	local line = vim.fn.line(".")
	if vim.fn.foldclosed(line) ~= -1 then
		vim.cmd("normal! zO")
		return
	end
	-- `zc` on a closed fold closes the fold enclosing it, so this walks outwards
	-- one level per step. It only shows after the fact whether the fold it just
	-- closed started here too; when it didn't, `zo` hands that one back.
	local closed_to = 0
	while pcall(vim.cmd, "normal! zc") do
		local start, stop = vim.fn.foldclosed(line), vim.fn.foldclosedend(line)
		if start ~= line then
			if closed_to > 0 then
				vim.cmd("normal! zo")
			end
			break
		end
		if stop <= closed_to then -- nothing grew: no fold left to close
			break
		end
		closed_to = stop
	end
end

vim.keymap.set("n", "<backspace>", toggle_fold, { desc = "Toggle fold" })

-- jump to the next/previous line sharing the current indentation level
local function jump_to_same_indent(direction)
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	local total_lines = vim.api.nvim_buf_line_count(0)
	local line_text = vim.api.nvim_buf_get_lines(0, current_line - 1, current_line, false)[1]
	local current_indent = line_text:match("^%s*"):len()

	local from = current_line + direction
	local to = direction > 0 and total_lines or 1
	for i = from, to, direction do
		local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
		if line and line:match("%S") then -- non-blank line
			if line:match("^%s*"):len() == current_indent then
				vim.api.nvim_win_set_cursor(0, { i, current_indent })
				return
			end
		end
	end
end

vim.keymap.set("n", "<space>i", function()
	jump_to_same_indent(1)
end, { desc = "Go to next line with same indentation" })
vim.keymap.set("n", "<space>I", function()
	jump_to_same_indent(-1)
end, { desc = "Go to previous line with same indentation" })
