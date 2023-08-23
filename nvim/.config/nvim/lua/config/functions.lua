local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

function trim(s)
	return s:match '^%s*(.*%S)' or ''
end

local function to_relative_path(path, base)
	local fileHandle    = assert(io.popen('realpath --relative-to ' .. base .. ' ' .. path, 'r'))
	local commandOutput = assert(fileHandle:read('*a'))
	commandOutput       = commandOutput:sub(1, -2)
	fileHandle:close()
	return commandOutput
end

local M = {}

local function selection_by_index(prompt_bufnr)
	local selections = {}
	local index = 1
	require('telescope.actions.utils').map_selections(prompt_bufnr, function(entry)
		selections[index] = entry.value
		index = index + 1
	end)
	return selections
end

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
				local selections = selection_by_index(prompt_bufnr)
				actions.close(prompt_bufnr)
				local size = 0
				for _ in pairs(selections) do size = size + 1 end
				print(size)
				if size == 0 then
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
					return
				end
				local paths = {}
				local l = 0
				for i, selection in pairs(selections) do
					local path
					l = l + 1
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
					paths[i] = path
				end

				if l == 1 then
					vim.api.nvim_put({ paths[1] }, 'c', false, true)
					vim.cmd('normal i')
					vim.cmd('call cursor( line("."), col(".") + 1)')
				else
					print('multiple')
					for index, path in ipairs(paths) do
						vim.api.nvim_put({ path }, '', false, true)
						vim.cmd('normal o')
					end
					vim.cmd('normal "_ddA')
					vim.cmd('call cursor( line("."), col(".") + 1)')
				end
			end)
			return true
		end,
	}):find()
end

function M.split()
	vim.ui.input(
		{ prompt = 'separator: ' },
		function(sep)
			local contents = vim.fn.getreg('+', 1, 1)
			local content = table.concat(contents, " ")
			local t = {}
			for str in string.gmatch(content, "([^" .. sep .. "]+)") do
				table.insert(t, str)
			end
			vim.fn.setreg('+', t)
		end)
end

function M.join()
	vim.ui.input(
		{ prompt = 'separator: ' },
		function(sep)
			local contents = vim.fn.getreg('+', 1, 1)
			for i, content in pairs(contents) do
				contents[i] = trim(content)
			end
			local output = table.concat(contents, sep)
			vim.fn.setreg('+', output)
			print('set clipboard to \'' .. output .. '\'')
		end)
end

function M.surround()
	vim.ui.input(
		{ prompt = 'surrounding: ' },
		function(sep)
			local content = vim.fn.getreg('+', 1, 1)
			local newcontent = {}
			for i, element in pairs(content) do
				newcontent[i] = sep .. element .. sep
				print(i .. " " .. element)
			end
			vim.fn.setreg('+', newcontent)
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

local telescope = require('telescope.builtin')
local telescope_last = 0
function M.telescope_resume()
	if telescope_last == 0 then
		telescope_last = 1
		telescope.live_grep()
	else
		telescope.resume()
	end
end

function M.setreg(to, from)
	vim.fn.setreg(to, vim.fn.getreg(from, 1, 1))
end

return M
