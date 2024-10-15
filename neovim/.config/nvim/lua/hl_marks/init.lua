local marks = require('hl_marks.marks')
local storage = require('hl_marks.storage')
local memory = require('hl_marks.memory')

marks.initialize_highlights()


local function save_on_leave()
  local cwd_path = vim.fn.getcwd()
  local buffer = vim.api.nvim_get_current_buf()
  local buffer_path = vim.api.nvim_buf_get_name(buffer)
  local mark_ids = memory.get_buffer_mark_ids(buffer_path)

  storage.save_buffer_marks(cwd_path, buffer, buffer_path, mark_ids)
end

local function load_on_enter()
    local cwd_path = vim.fn.getcwd()
    local buffer = vim.api.nvim_get_current_buf()
    local buffer_path = vim.api.nvim_buf_get_name(buffer)

    storage.load_buffer_marks(cwd_path, buffer, buffer_path)
end

vim.api.nvim_create_autocmd("BufUnload", {
  callback = save_on_leave,
})

-- vim.api.nvim_create_autocmd("BufReadPost", {
--   callback = load_on_enter,
-- })

vim.keymap.set('n', "'", save_on_leave, { desc = 'Save' })
vim.keymap.set('n', '"', load_on_enter, { desc = 'Load' })
vim.keymap.set('x', "'", marks.set_visual, { desc = 'Set HL mark' })
vim.keymap.set('n', "<space>x", marks.remove, { desc = 'Remove HL mark' })
