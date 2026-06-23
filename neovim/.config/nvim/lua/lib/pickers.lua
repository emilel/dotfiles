-- Telescope-backed pickers that are wired to global keymaps. The plugin specs
-- (lua/plugins/telescope.lua, lua/plugins/nnn.lua) only reference these, so the
-- specs stay declarative and the logic lives in one discoverable place.
local M = {}

local ignore = {
	".git",
	".venv",
	".vscode",
	".databricks",
	".pytest_cache",
	".mypy_cache",
	"__pycache__",
}

local function read_lines(path)
	local f = io.open(path, "r")
	if not f then
		return nil, ("Could not open: %s"):format(path)
	end
	local out = {}
	for line in f:lines() do
		if line ~= "" then
			table.insert(out, line)
		end
	end
	f:close()
	return out
end

-- Pick a snippet from <cwd>/.setup/paste and insert it at the cursor.
M.paste = function()
	local file = vim.fn.getcwd() .. "/.setup/paste"
	local lines, err = read_lines(file)
	if not lines then
		return vim.notify(err, vim.log.levels.WARN)
	end
	if #lines == 0 then
		return vim.notify("No entries in " .. file, vim.log.levels.INFO)
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = "Paste",
			finder = finders.new_table({ results = lines }),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local entry = action_state.get_selected_entry()
					local text = (entry and (entry.value or entry[1])) or nil
					if not text then
						return
					end
					local row, col = unpack(vim.api.nvim_win_get_cursor(0))
					row = row - 1
					vim.api.nvim_buf_set_text(0, row, col, row, col, { text })
					vim.api.nvim_win_set_cursor(0, { row + 1, col + #text })
				end)
				return true
			end,
		})
		:find()
end

-- Pick a directory (via Telescope/fd) and open nnn rooted there.
M.directory_then_nnn = function()
	local source_win = vim.api.nvim_get_current_win()

	local ok_lazy, lazy = pcall(require, "lazy")
	if ok_lazy then
		lazy.load({ plugins = { "telescope.nvim" } })
	end

	local cwd = vim.fn.getcwd()

	local cmd
	if vim.fn.executable("fd") == 1 then
		cmd = { "fd", "--type", "d", "--hidden", "--follow" }
		for _, x in ipairs(ignore) do
			table.insert(cmd, "--exclude")
			table.insert(cmd, x)
		end
		table.insert(cmd, ".")
	else
		cmd = { "find", ".", "-type", "d" }
		for _, x in ipairs(ignore) do
			table.insert(cmd, "-not")
			table.insert(cmd, "-path")
			table.insert(cmd, "./" .. x .. "/*")
		end
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = "Directories",
			finder = finders.new_oneshot_job(cmd, { cwd = cwd }),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					local entry = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					local dir = entry and (entry.path or entry.value or entry[1]) or nil
					if not dir or dir == "." then
						dir = cwd
					elseif not dir:match("^/") then
						dir = cwd .. "/" .. dir
					end

					-- Run NnnPicker from the original window, once Telescope is gone.
					vim.schedule(function()
						if vim.api.nvim_win_is_valid(source_win) then
							vim.api.nvim_set_current_win(source_win)
						end
						vim.cmd("NnnPicker " .. vim.fn.fnameescape(dir))
						vim.schedule(function()
							pcall(vim.cmd, "startinsert")
						end)
					end)
				end)
				return true
			end,
		})
		:find()
end

return M
