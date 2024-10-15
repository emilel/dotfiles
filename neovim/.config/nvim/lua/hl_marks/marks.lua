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

  memory.save_buffer_mark_id(buffer_path, mark_id)
end

M.remove = function()
  local buffer = vim.api.nvim_get_current_buf()
  local buffer_path = vim.api.nvim_buf_get_name(buffer)
  local buffer_mark_ids = memory.get_buffer_mark_ids(buffer_path)
  local cursor_position = cursor.get_position()
  print(vim.inspect(cursor_position))
  for _, mark_id in ipairs(buffer_mark_ids) do
    local mark_info = M.get_mark_info(buffer, mark_id)
    print(vim.inspect(mark_info))
  end
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

M.get_mark_info = function(buffer, mark_id)
  local position = vim.api.nvim_buf_get_extmark_by_id(buffer, namespace, mark_id, { details = true })
  local selection = { start = { row = position[1] + 1, col = position[2] + 1 }, finish = { row = position[3].end_row + 1, col = position[3].end_col } }
  local row_text = vim.api.nvim_buf_get_lines(buffer, selection.start.row - 1, selection.start.row, true)[1]

  local highlighted_text
  if selection.start.row == selection.finish.row then
    highlighted_text = row_text:sub(selection.start.col, selection.finish.col)
  else
    highlighted_text = row_text:sub(selection.start.col)
  end

  local mark_info = { selection = selection, row_text = row_text, highlighted_text = highlighted_text }

  return mark_info
end

M.get_all_mark_infos = function()
  local mark_ids = memory.get_all_mark_ids()
  local mark_infos = {}
  for buffer_path, ids in pairs(mark_ids) do
    local buffer = vim.fn.bufnr(buffer_path)
    -- TODO
    if buffer ~= -1 then
      for _, mark_id in ipairs(ids) do
        local mark_info = M.get_mark_info(buffer, mark_id)
        table.insert(mark_infos, mark_info)
      end
    end
  end

  return mark_infos
end

return M
