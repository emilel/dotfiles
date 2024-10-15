local utils = require "hl_marks.utils"
local data_directory = vim.fn.stdpath('data') .. '/hl_marks'

local function get_buffer_data_path(cwd_directory, buffer_path)
  local relative_path = utils.get_relative_path(cwd_directory, buffer_path)
  local buffer_data_path = data_directory .. cwd_directory .. "/" .. relative_path .. ".json"

  return buffer_data_path
end

local M = {}

M.store_buffer_marks = function(cwd_directory, buffer_path, mark_infos)
  local buffer_data_path = get_buffer_data_path(cwd_directory, buffer_path)

  local file = io.open(buffer_data_path, "w")
  if file then
    file:write(vim.fn.json_encode(mark_infos))
    file:close()
  end
end

M.read_buffer_mark_infos = function(cwd_path, buffer_path)
  local relative_path = vim.fn.fnamemodify(buffer_path, ":."):gsub("^" .. cwd_path .. "/", "")
  local file_path = data_directory .. cwd_path .. "/" .. relative_path .. ".json"
  local file = io.open(file_path, "r")
  if not file then
    return {}
  end

  local json_data = file:read("*a")
  file:close()

  local mark_infos = vim.fn.json_decode(json_data) or {}

  return mark_infos
end

return M
