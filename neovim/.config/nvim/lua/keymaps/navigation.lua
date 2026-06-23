-- Moving around: horizontal scroll, folds, indentation-aware jumps.

-- horizontal scroll
vim.keymap.set("n", "H", "zH", { desc = "Scroll to the left" })
vim.keymap.set("n", "L", "zL", { desc = "Scroll to the right" })

-- toggle the fold under the cursor
vim.keymap.set("n", "<backspace>", "za", { desc = "Toggle fold" })

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
