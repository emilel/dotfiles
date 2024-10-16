local M = {}

M.leave_visual_mode = function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
end

M.get_relative_path = function(cwd_directory, buffer_path)
  local relative_path = vim.fn.fnamemodify(buffer_path, ":."):gsub("^" .. cwd_directory .. "/", "")

  return relative_path
end

M.get_parent = function(path)
  return vim.fn.fnamemodify(path, ":h")
end

return M
