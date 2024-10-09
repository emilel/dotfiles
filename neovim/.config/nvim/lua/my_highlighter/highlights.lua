-- highlights.lua
local M = {}
local storage = require('my_highlighter.storage')

-- Define the highlight group 'MyHighlighter'
vim.api.nvim_set_hl(0, 'MyHighlighter', { fg = '#282828', bg = '#ebdbb2', default = true })

M.ns_id = vim.api.nvim_create_namespace('MyHighlighterNS')
M.extmarks = {}

-- Add a new highlight
function M.add_highlight()
  local buffer = vim.api.nvim_get_current_buf()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  -- Convert to 0-indexed positions
  local start_row = start_pos[2] - 1
  local start_col = start_pos[3] - 1
  local end_row = end_pos[2] - 1
  local end_col = end_pos[3] - 1

  -- Create extmark with highlight
  local extmark_id = vim.api.nvim_buf_set_extmark(
    buffer,
    M.ns_id,
    start_row,
    start_col,
    {
      end_row = end_row,
      end_col = end_col + 1, -- 'end_col' is exclusive
      hl_group = 'MyHighlighter',
      hl_mode = 'combine',
    }
  )

  -- Store extmark data in memory
  table.insert(M.extmarks, {
    buffer = buffer,
    extmark_id = extmark_id,
  })

  -- Save the position to storage
  storage.save_highlights(M.get_all_positions())
end

-- Remove a highlight
function M.remove_highlight(extmark)
  vim.api.nvim_buf_del_extmark(extmark.buffer, M.ns_id, extmark.extmark_id)
  -- Remove from in-memory extmarks
  for i, mark in ipairs(M.extmarks) do
    if mark.extmark_id == extmark.extmark_id and mark.buffer == extmark.buffer then
      table.remove(M.extmarks, i)
      break
    end
  end
  -- Save updated positions to storage
  storage.save_highlights(M.get_all_positions())
end

-- Load highlights from storage
function M.load_highlights()
  local positions = storage.load_highlights()
  M.extmarks = {} -- Clear current extmarks
  for _, pos in ipairs(positions) do
    local buffer = vim.fn.bufnr(pos.filepath, true)
    if buffer ~= -1 then
      vim.fn.bufload(buffer)
      local extmark_id = vim.api.nvim_buf_set_extmark(
        buffer,
        M.ns_id,
        pos.start_row,
        pos.start_col,
        {
          end_row = pos.end_row,
          end_col = pos.end_col + 1, -- 'end_col' is exclusive
          hl_group = 'MyHighlighter',
          hl_mode = 'combine',
        }
      )
      table.insert(M.extmarks, {
        buffer = buffer,
        extmark_id = extmark_id,
      })
    end
  end
end

-- **Add the 'reload_highlights' function**
function M.reload_highlights()
  -- Clear existing extmarks
  for _, mark in ipairs(M.extmarks) do
    pcall(vim.api.nvim_buf_del_extmark, mark.buffer, M.ns_id, mark.extmark_id)
  end
  -- Reload highlights from storage
  M.load_highlights()
end

-- Get all extmark positions for saving
function M.get_all_positions()
  local positions = {}
  for _, mark in ipairs(M.extmarks) do
    local pos = vim.api.nvim_buf_get_extmark_by_id(mark.buffer, M.ns_id, mark.extmark_id, { details = true })
    if pos then
      table.insert(positions, {
        filepath = vim.api.nvim_buf_get_name(mark.buffer),
        start_row = pos[1],
        start_col = pos[2],
        end_row = pos[3].end_row,
        end_col = pos[3].end_col - 1, -- Adjust because 'end_col' is exclusive
      })
    end
  end
  return positions
end

-- Get highlights for Telescope picker
function M.get_highlights_for_picker()
  local entries = {}
  for _, mark in ipairs(M.extmarks) do
    local buffer = mark.buffer
    local extmark_id = mark.extmark_id
    local pos = vim.api.nvim_buf_get_extmark_by_id(buffer, M.ns_id, extmark_id, { details = true })
    if pos then
      local filepath = vim.api.nvim_buf_get_name(buffer)
      local line = vim.api.nvim_buf_get_lines(buffer, pos[1], pos[1] + 1, false)[1] or ''
      local display_text = string.format('%s:%d:%d: %s', vim.fn.fnamemodify(filepath, ':.'),
        pos[1] + 1, pos[2] + 1, line)
      table.insert(entries, {
        buffer = buffer,
        extmark_id = extmark_id,
        display_text = display_text,
      })
    end
  end
  return entries
end

-- Jump to a highlight
function M.jump_to_highlight(mark)
  local pos = vim.api.nvim_buf_get_extmark_by_id(mark.buffer, M.ns_id, mark.extmark_id, {})
  if pos then
    vim.fn.bufload(mark.buffer)
    vim.api.nvim_set_current_buf(mark.buffer)
    vim.api.nvim_win_set_cursor(0, { pos[1] + 1, pos[2] + 1 })
  end
end

return M
