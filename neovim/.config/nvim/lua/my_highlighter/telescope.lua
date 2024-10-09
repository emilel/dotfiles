-- telescope.lua
local M = {}
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values
local highlights = require('my_highlighter.highlights')

function M.highlight_picker()
  local hl_data = highlights.get_highlights_for_picker()
  if vim.tbl_isempty(hl_data) then
    vim.api.nvim_err_writeln("No highlights found")
    return
  end

  pickers.new({}, {
    prompt_title = 'Highlights',
    finder = finders.new_table {
      results = hl_data,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.display_text,
          ordinal = entry.display_text,
        }
      end
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        highlights.jump_to_highlight(selection.value)
      end)
      -- Optional: Map a key to remove the highlight
      local function delete_highlight()
        local selection = action_state.get_selected_entry()
        if selection then
          highlights.remove_highlight(selection.value)
          actions.close(prompt_bufnr)
          M.highlight_picker()
        end
      end
      map('n', 'd', delete_highlight)  -- Press 'd' in normal mode to delete
      map('i', '<C-d>', delete_highlight)  -- Press Ctrl+D in insert mode to delete
      return true
    end
  }):find()
end

return M
