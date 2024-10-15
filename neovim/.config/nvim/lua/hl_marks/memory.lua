local mark_ids = {}

local M = {}

M.save_buffer_mark_id = function(buffer_path, mark_id)
  if not mark_ids[buffer_path] then
    mark_ids[buffer_path] = {}
  end
  table.insert(mark_ids[buffer_path], mark_id)
end

M.remove_buffer_mark_id = function(buffer_path, mark_id)
  if not mark_ids[buffer_path] then
    return
  end
  for i, id in ipairs(mark_ids[buffer_path]) do
    if id == mark_id then
      table.remove(mark_ids[buffer_path], i)
      break
    end
  end
end

M.get_buffer_mark_ids = function(buffer_path)
  return mark_ids[buffer_path] or {}
end

M.get_all_mark_ids = function()
  return mark_ids
end

return M
