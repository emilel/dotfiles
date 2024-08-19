local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

local M = {}

M.go_to_directory = function()
  pickers.new({}, {
    prompt_title = "Find Folders",
    finder = finders.new_oneshot_job({ "fd", "--type", "d", "--hidden", "--exclude", ".git" }, {}),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd('NnnPicker ' .. vim.fn.fnameescape(selection[1]))
        vim.defer_fn(function()
          vim.cmd('startinsert')
        end, 100)
      end)
      return true
    end,
  }):find()
end

return M
