local M = {}

-- Toggle the fold under the cursor. Several folds can start on the same line --
-- a python `def` whose signature wraps opens both a `function_definition` and a
-- `parameters` fold on the `def` line -- and plain `za` would close only the
-- innermost, folding the signature and leaving the body. So keep closing while
-- the folds still start on the cursor line, and open recursively to undo that.
-- With a UI attached, treesitter parses in time-sliced chunks, and on a large
-- file (a 35k-line json) that parse never finishes on its own: the foldexpr
-- keeps answering 0 everywhere, so there is nothing to close. `zx` makes it
-- recompute against a full parse. Only when the tree isn't valid yet -- then
-- there are no folds whose open/closed state `zx` could throw away.
local function ensure_treesitter_folds(line)
	if vim.fn.foldlevel(line) ~= 0 or not vim.wo.foldexpr:find("treesitter") then
		return
	end
	local ok, parser = pcall(vim.treesitter.get_parser)
	if ok and parser and not parser:is_valid() then
		vim.cmd("normal! zx")
	end
end

function M.toggle()
	local line = vim.fn.line(".")
	ensure_treesitter_folds(line)
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

return M
