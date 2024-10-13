local mark_ids = {}

local M = {}

M.save = function(buffer_path, mark_id)
  if not mark_ids[buffer_path] then
    mark_ids[buffer_path] = {}
  end
  table.insert(mark_ids[buffer_path], mark_id)
end

M.get = function(buffer_path)
  return mark_ids[buffer_path]
end

return M
