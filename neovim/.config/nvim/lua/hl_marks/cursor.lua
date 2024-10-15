local M = {}

M.get_visual_start = function()
  local _, start_row, start_col, _ = unpack(vim.fn.getpos('v'))

  return { row = start_row, col = start_col }
end

M.get_visual_end = function()
  local _, end_row, end_col, _ = unpack(vim.fn.getpos('.'))

  return { row = end_row, col = end_col }
end

M.get_visual_selection = function()
  local start_pos = M.get_visual_start()
  local end_pos = M.get_visual_end()
  if (start_pos.row > end_pos.row) or (start_pos.row == end_pos.row and start_pos.col > end_pos.col) then
    start_pos, end_pos = end_pos, start_pos
  end
  local position = { start = start_pos, finish = end_pos }

  return position
end

M.get_position = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  return { row = row, col = col + 1 }
end

return M
