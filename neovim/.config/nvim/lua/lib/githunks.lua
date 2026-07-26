-- gitsigns' setqflist("all") walks `git status --porcelain` but only keeps
-- worktree-modified (`.M`), deleted and untracked (`??`) entries. A file staged
-- with `git add -N` reads ` A`, so it drops out of the repo-wide list even
-- though its gutter shows the whole file as one add hunk (the index blob is
-- empty). Fill that gap ourselves.
local M = {}

-- Paths from `git status --porcelain -z` output that are intent-to-add.
-- Pure given the split records, so unit-testable.
M.intent_to_add = function(records)
	local paths = {}
	for _, record in ipairs(records) do
		if record:sub(1, 3) == " A " then
			paths[#paths + 1] = record:sub(4)
		end
	end
	return paths
end

-- vim.system, not vim.fn.system: the latter rewrites the NUL separators of
-- `-z` output to SOH.
local git = function(args)
	local out = vim.system(vim.list_extend({ "git" }, args), { text = true }):wait()
	return out.code == 0 and out.stdout or nil
end

-- Quickfix items for the intent-to-add files in the cwd's repo, formatted the
-- way gitsigns formats its own. One entry per file: an empty index blob means
-- the whole file is a single add hunk starting at line 1.
M.qf_items = function()
	local root = git({ "rev-parse", "--show-toplevel" })
	-- -z keeps paths raw (no core.quotePath escaping) and NUL-separated.
	local status = root and git({ "status", "--porcelain", "-z", "--ignore-submodules" })
	if not status then
		return {}
	end

	root = vim.trim(root)
	local items = {}
	for _, path in ipairs(M.intent_to_add(vim.split(status, "\0"))) do
		local file = root .. "/" .. path
		local lines = vim.fn.filereadable(file) == 1 and vim.fn.readfile(file) or {}
		items[#items + 1] = {
			filename = file,
			lnum = 1,
			text = ("%-7s (-0,0 +1,%d): %s"):format("Added", #lines, lines[1] or ""),
		}
	end
	return items
end

return M
