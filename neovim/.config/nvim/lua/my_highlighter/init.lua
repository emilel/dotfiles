-- init.lua
local highlights = require('my_highlighter.highlights')
local config = require('my_highlighter.config')

-- Load existing highlights
-- highlights.load_highlights()

-- Set up key mapping for visual mode
vim.api.nvim_set_keymap('v', "'", ':<C-U>lua require("my_highlighter.highlights").add_highlight()<CR>', { noremap = true, silent = true })

-- Set up key mapping to open the Telescope picker
vim.api.nvim_set_keymap('n', '<space>"', ':lua require("my_highlighter.telescope").highlight_picker()<CR>', { noremap = true, silent = true })

-- Save highlights before exiting Neovim
vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    -- Save all extmark positions
    require('my_highlighter.storage').save_highlights(require('my_highlighter.highlights').get_all_positions())
  end
})

-- Reload highlights when buffers are read
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    require('my_highlighter.highlights').reload_highlights()
  end
})
