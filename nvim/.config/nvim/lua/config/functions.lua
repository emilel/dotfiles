local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local function to_relative_path(path, base)
	local fileHandle    = assert(io.popen('realpath --relative-to ' .. base .. ' ' .. path, 'r'))
	local commandOutput = assert(fileHandle:read('*a'))
	commandOutput = commandOutput:sub(1, -2)
	fileHandle:close()
	return commandOutput
end

local M = {}

function M.insert_path(opts)
	opts = opts or { rel = 'cwd' }
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
				local path
				if opts.rel == 'file' then
					local base = vim.fn.expand("%:h")
					if base == '' then
						base = '.'
					end
					path = to_relative_path(selection, base)
				elseif opts.rel == 'cwd' then
					path = selection
				else
					path = opts.base
				end
				vim.api.nvim_put({ path }, 'c', false, true)
				vim.cmd('normal i')
				vim.cmd('call cursor( line("."), col(".") + 1)')
			end)
			return true
		end,
	}):find()
end

function M.join()
	vim.ui.input(
		{ prompt = 'Separator: ' },
		function(sep)
			local content = vim.fn.getreg('+', 1, 1)
			local output = table.concat(content, sep)
			vim.api.nvim_put({ output }, '', true, true)
		end)
end

function M.list_snips()
	local ft_list = require("luasnip").available()[vim.o.filetype]
	local ft_snips = {}
	for _, item in pairs(ft_list) do
		ft_snips[item.trigger] = item.name
	end
	print(vim.inspect(ft_snips))
end

return M
