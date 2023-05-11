local pickers = require "telescope.pickers"
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local function to_relative_path(path, base)
	local fileHandle     = assert(io.popen('realpath --relative-to ' .. base .. ' ' .. path, 'r'))
	local commandOutput  = assert(fileHandle:read('*a'))
	fileHandle:close()
	return commandOutput
end

local opts = {}
local find_command = { 'fd', '--hidden' }
pickers.new(opts, {
	prompt_title = "File",
	finder = finders.new_oneshot_job(find_command, opts),
	previewer = conf.file_previewer(opts),
	sorter = conf.file_sorter(opts),
	attach_mappings = function(prompt_bufnr, _)
		actions.select_default:replace(function()
			actions.close(prompt_bufnr)
			local selection = action_state.get_selected_entry()[1]
			vim.api.nvim_put({ to_relative_path(selection) }, 'c', false, true)
			vim.cmd('normal i')
			vim.cmd('call cursor( line("."), col(".") + 1)')
		end)
		return true
	end,
}):find()
