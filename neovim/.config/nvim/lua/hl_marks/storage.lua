local marks = require('hl_marks.marks')

local data_directory = vim.fn.stdpath('data') .. '/hl_marks'

local M = {}

M.save_buffer_marks = function(cwd_path, buffer, buffer_path, mark_ids)
  if mark_ids == nil or #mark_ids == 0 then return end

  local mark_infos = {}
  for _, mark_id in ipairs(mark_ids) do
    local mark = marks.get_info(buffer, mark_id)
    mark_infos[mark_id] = mark
  end

  local cwd_directory = data_directory .. cwd_path
  vim.fn.mkdir(cwd_directory, "p")

  local relative_path = vim.fn.fnamemodify(buffer_path, ":."):gsub("^" .. cwd_path .. "/", "")
  local file_path = cwd_directory .. "/" .. relative_path .. ".json"
  local file = io.open(file_path, "w")
  if file then
    file:write(vim.fn.json_encode(mark_infos))
    file:close()
  end
end

M.load_buffer_marks = function(cwd_path, buffer, buffer_path)
  local relative_path = vim.fn.fnamemodify(buffer_path, ":."):gsub("^" .. cwd_path .. "/", "")
  local file_path = data_directory .. cwd_path .. "/" .. relative_path .. ".json"

  local file = io.open(file_path, "r")
  if not file then
    return
  end

  local json_data = file:read("*a")
  file:close()

  local mark_infos = vim.fn.json_decode(json_data)
  if not mark_infos then
    return
  end

  for _, mark_info in pairs(mark_infos) do
    marks.set(buffer, mark_info.selection.start, mark_info.selection.finish)
  end
end

return M
