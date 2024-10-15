local api = require('hl_marks.api')

api.initialize()

vim.api.nvim_create_autocmd("BufUnload", {
  callback = api.save_buffer_marks,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = api.load_buffer_marks,
})

vim.keymap.set('x', "'", api.set_visual, { desc = 'Set HL mark' })
vim.keymap.set('n', "<space>x", api.remove_normal, { desc = 'Remove HL mark' })
vim.keymap.set('n', "<space>a", api.find_hl_marks, { desc = 'Jump to HL mark' })
