local memory = require('hl_marks.memory')
local marks = require('hl_marks.marks')
local utils = require('hl_marks.utils')
local cursor = require('hl_marks.cursor')
local storage = require('hl_marks.storage')
local pickers = require("hl_marks.pickers")

local function set(buffer, start, finish)
  local mark_id = marks.set(buffer, start, finish)
  memory.save_buffer_mark_id(buffer, mark_id)
end

local function load_buffer_marks(buffer, buffer_path)
  local cwd_path = vim.fn.getcwd()
  local mark_infos = storage.read_buffer_mark_infos(cwd_path, buffer_path)

  for _, mark_info in ipairs(mark_infos) do
    set(buffer, mark_info.selection.start, mark_info.selection.finish)
  end
end

local M = {}

M.initialize = function()
  marks.initialize_highlights()
end

M.set_visual = function()
  local buffer = vim.api.nvim_get_current_buf()
  local selection = cursor.get_visual_selection()
  set(buffer, selection.start, selection.finish)
  utils.leave_visual_mode()
end

M.load_buffer_marks = function()
  local buffer = vim.api.nvim_get_current_buf()
  local buffer_path = vim.api.nvim_buf_get_name(buffer)
  load_buffer_marks(buffer, buffer_path)
end

M.save_buffer_marks = function()
  local buffer = vim.api.nvim_get_current_buf()
  local buffer_path = vim.api.nvim_buf_get_name(buffer)
  local cwd_directory = vim.fn.getcwd()
  local mark_ids = memory.get_buffer_mark_ids(buffer)
  local mark_infos = marks.get_buffer_mark_infos(buffer, mark_ids)

  storage.store_buffer_marks(cwd_directory, buffer_path, mark_infos)
end

M.remove_normal = function()
  local buffer = vim.api.nvim_get_current_buf()
  local cursor_position = cursor.get_position()
  local mark_ids = memory.get_buffer_mark_ids(buffer)
  for _, mark_id in ipairs(mark_ids) do
    local mark_info = marks.get_buffer_mark_info(buffer, mark_id)
    if mark_info.selection.start.row <= cursor_position.row and
        cursor_position.row <= mark_info.selection.finish.row and
        mark_info.selection.start.col <= cursor_position.col and
        cursor_position.col <= mark_info.selection.finish.col
    then
      marks.remove(buffer, mark_id)
      memory.remove_buffer_mark_id(buffer, mark_id)
    end
  end
end

M.find_hl_marks = function()
  local all_mark_ids = memory.get_all_mark_ids()
  local all_mark_infos = marks.get_all_mark_infos(all_mark_ids)
  pickers.jump_to_hl_mark(all_mark_infos)
end


return M
