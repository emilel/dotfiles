local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

local M = {}

M.find_folders = function()
  pickers.new({}, {
    prompt_title = "Find Folders",
    finder = finders.new_oneshot_job({ "fd", "--type", "d" }, {}),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd('NnnPicker ' .. vim.fn.fnameescape(selection[1]))
      end)
      return true
    end,
  }):find()
end

return M
