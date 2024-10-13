local cursor = require('hl_marks.cursor')
local utils = require('hl_marks.utils')
local memory = require('hl_marks.memory')

local namespace = vim.api.nvim_create_namespace('hl_marks')
local highlights = {
  HLMark0 = { bg = '#4c4846', default = true },
}

local M = {}

M.set = function(buffer, start, finish)
  local buffer_path = vim.api.nvim_buf_get_name(buffer)
  local mark_id = vim.api.nvim_buf_set_extmark(buffer, namespace, start.row - 1, start.col - 1,
    { end_row = finish.row - 1, end_col = finish.col, hl_group = 'HLMark0' })

  memory.save(buffer_path, mark_id)
end

M.initialize_highlights = function()
  for name, options in pairs(highlights) do
    vim.api.nvim_set_hl(0, name, options)
  end
end

M.set_visual = function()
  local buffer = vim.api.nvim_get_current_buf()
  local selection = cursor.get_visual_selection()
  M.set(buffer, selection.start, selection.finish)
  utils.press_escape()
end

M.get_info = function(buffer, mark_id)
  local position = vim.api.nvim_buf_get_extmark_by_id(buffer, namespace, mark_id, { details = true })
  local selection = { start = { row = position[1] + 1, col = position[2] + 1 }, finish = { row = position[3].end_row + 1, col = position[3].end_col } }
  local row_text = vim.api.nvim_buf_get_lines(buffer, selection.start.row, selection.start.row + 1, true)[1]

  local highlighted_text
  if selection.start.row == selection.finish.row then
    highlighted_text = row_text:sub(selection.start.col + 1, selection.finish.col - 1)
  else
    highlighted_text = row_text:sub(selection.start.col + 1)
  end

  return { selection = selection, row_text = row_text, highlighted_text = highlighted_text }
end

return M
