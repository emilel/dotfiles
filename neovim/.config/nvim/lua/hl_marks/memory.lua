local mark_ids = {}

local M = {}

M.save_buffer_mark_id = function(buffer, mark_id)
  if not mark_ids[buffer] then
    mark_ids[buffer] = {}
  end
  table.insert(mark_ids[buffer], mark_id)
end

M.remove_buffer_mark_id = function(buffer, mark_id)
  if not mark_ids[buffer] then
    return
  end
  for i, id in ipairs(mark_ids[buffer]) do
    if id == mark_id then
      table.remove(mark_ids[buffer], i)
      break
    end
  end
end

M.get_buffer_mark_ids = function(buffer)
  return mark_ids[buffer] or {}
end

M.get_all_mark_ids = function()
  return mark_ids
end

return M
