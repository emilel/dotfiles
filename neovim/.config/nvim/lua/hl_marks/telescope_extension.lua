local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")

local M = {}

M.jump_to_hl_mark = function(all_mark_infos, opts)
  opts = opts or {}

  if #all_mark_infos == 0 then
    print("No marks found")
    return
  end

  local displayer = entry_display.create({
    separator = " ",
    items = {
      {},
      { remaining = true, hl = "Function" },
    },
  })

  pickers.new(opts, {
    prompt_title = "Jump to HLMark",
    finder = finders.new_table({
      results = all_mark_infos,
      entry_maker = function(entry)
        return {
          value = entry,
          display = displayer({
            { entry.highlighted_text },
            { entry.path },
          })
          ,
          ordinal = entry.row_text,
        }
      end
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry().value
        actions.close(prompt_bufnr)

        local window_id = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(window_id, selection.buffer)

        local row = selection.selection.start.row
        local col = selection.selection.start.col
        vim.api.nvim_win_set_cursor(window_id, { row, col })
      end)
      return true
    end,
  }):find()
end

return M
