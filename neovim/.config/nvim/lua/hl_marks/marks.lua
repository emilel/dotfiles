local utils = require('hl_marks.utils')

local namespace = vim.api.nvim_create_namespace('hl_marks')
local highlights = {
  HLMark0 = { bg = '#6b4537' },
}

local M = {}

M.initialize_highlights = function()
  for name, options in pairs(highlights) do
    vim.api.nvim_set_hl(0, name, options)
  end
end

M.set = function(buffer, start, finish)
  local mark_id = vim.api.nvim_buf_set_extmark(buffer, namespace, start.row - 1, start.col - 1,
    { end_row = finish.row - 1, end_col = finish.col, hl_group = 'HLMark0' })

  return mark_id
end

M.remove = function(buffer, mark_id)
  local success = vim.api.nvim_buf_del_extmark(buffer, namespace, mark_id)

  return success
end

M.get_buffer_mark_info = function(buffer, mark_id)
  local buffer_path = vim.api.nvim_buf_get_name(buffer)
  local cwd_directory = vim.fn.getcwd()
  local relative_buffer_path = utils.get_relative_path(cwd_directory, buffer_path)
  local position = vim.api.nvim_buf_get_extmark_by_id(buffer, namespace, mark_id, { details = true })
  local selection = {
    start = { row = position[1] + 1, col = position[2] + 1 },
    finish = { row = position[3].end_row + 1, col = position[3].end_col }
  }
  local row_text = vim.api.nvim_buf_get_lines(buffer, selection.start.row - 1, selection.start.row, true)[1]

  local highlighted_text
  if selection.start.row == selection.finish.row then
    highlighted_text = row_text:sub(selection.start.col, selection.finish.col)
  else
    highlighted_text = row_text:sub(selection.start.col)
  end

  local mark_info = {
    selection = selection,
    row_text = row_text,
    highlighted_text = highlighted_text,
    path = relative_buffer_path,
    buffer = buffer
  }

  return mark_info
end

M.get_buffer_mark_infos = function(buffer, mark_ids)
  local mark_infos = {}
  for _, mark_id in ipairs(mark_ids) do
    local mark_info = M.get_buffer_mark_info(buffer, mark_id)
    table.insert(mark_infos, mark_info)
  end

  return mark_infos
end

M.get_all_mark_infos = function(all_mark_ids)
  local mark_infos = {}
  for buffer_path, ids in pairs(all_mark_ids) do
    local buffer = vim.fn.bufnr(buffer_path)
    -- TODO
    if buffer ~= -1 then
      for _, mark_id in ipairs(ids) do
        local mark_info = M.get_buffer_mark_info(buffer, mark_id)
        table.insert(mark_infos, mark_info)
      end
    end
  end

  return mark_infos
end

return M
