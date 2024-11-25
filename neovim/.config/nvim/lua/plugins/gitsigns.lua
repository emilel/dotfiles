return {
  'lewis6991/gitsigns.nvim',
  keys = {
    { '<c-g>s', function() require('gitsigns').stage_hunk() end, desc = 'Stage hunk' },
    { '<c-g>s', function() require('gitsigns').stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, mode = 'x', desc = 'Stage hunk' },
    { '<c-g>u', function() require('gitsigns').undo_stage_hunk() end, desc = 'Undo hunk' },
    { '<c-g>x', function() require('gitsigns').reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, desc = 'Reset hunk' },
    { '<c-g>x', function() require('gitsigns').reset_hunk() end, mode = 'x', desc = 'Reset hunk' },
    { '<c-g>r', function() require('gitsigns').preview_hunk() end, desc = 'Preview hunk' },
    { '<c-g>r', function() require('gitsigns').toggle_deleted() end, desc = 'Toggle deleted' },
  },
  lazy = false,
  opts = {
    sign_priority=11,
  },
}
