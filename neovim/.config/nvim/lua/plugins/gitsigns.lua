return {
  'lewis6991/gitsigns.nvim',
  keys = {
    { '<c-g><c-s>', function() require('gitsigns').stage_hunk() end, desc = 'Stage hunk' },
    { '<c-g><c-u>', function() require('gitsigns').reset_hunk() end, desc = 'Reset hunk' },
    { '<c-g><c-x>', function() require('gitsigns').undo_stage_hunk() end, desc = 'Undo hunk' }
  },
  lazy = false,
  config = function()
    require('gitsigns').setup({})
  end
}
