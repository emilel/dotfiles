return {
  'luukvbaal/nnn.nvim',
  lazy = true,
  cmd = {
    'NnnPicker'
  },
  keys = {
    { '-', '<cmd>NnnPicker %:p:h<cr>', { desc = "Open file picker in current file's directory" } },
    { '_', '<cmd>NnnPicker<cr>', { desc = 'Open file picker in current working directory' } }
  },
  opts = {}
}
