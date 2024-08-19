return {
  'luukvbaal/nnn.nvim',
  lazy = true,
  cmd = {
    'NnnPicker'
  },
  keys = {
    { '-', '<cmd>NnnPicker %:p:h<cr>', { desc = 'Open file picker' } }
  },
  opts = {}
}
