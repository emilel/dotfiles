-- storage.lua
local M = {}
local config = require('my_highlighter.config')

function M.save_highlights(highlights)
  local data = vim.fn.json_encode(highlights)
  local file = io.open(config.storage_path, 'w')
  if file then
    file:write(data)
    file:close()
  end
end

function M.load_highlights()
  local file = io.open(config.storage_path, 'r')
  if file then
    local data = file:read('*a')
    file:close()
    local highlights = vim.fn.json_decode(data)
    return highlights or {}
  end
  return {}
end

return M
