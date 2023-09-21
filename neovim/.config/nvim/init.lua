vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
require('lazy').setup('plugins', { change_detection = { notify = false }})

require('general')
require('keymaps')
require('globals')
require('visual')
require('commands')

local telescope = require'telescope'
local finders = require'telescope.finders'
local pickers = require'telescope.pickers'
local actions = require'telescope.actions'
local conf = require'telescope.config'.values

telescope.setup{
  extensions = {
    nnn_picker = {
      -- Add any configuration options you want for your extension here
    }
  }
}

telescope.register_extension{
  exports = {
    nnn_picker = function(opts)
      opts = opts or {}

      -- Function to find directories. Adjust this to suit your needs.
      local function find_dirs()
        local dirs = {}
        local p = io.popen('find . -type d')
        for dir in p:lines() do
          table.insert(dirs, dir)
        end
        return dirs
      end

      pickers.new(opts, {
        prompt_title = 'Find Directories',
        finder = finders.new_table{
          results = find_dirs(),
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry,
              ordinal = entry,
            }
          end,
        },
        sorter = conf.file_sorter(opts),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            local selection = actions.get_selected_entry(prompt_bufnr)
            actions.close(prompt_bufnr)
            -- Run nnnPicker with the selected directory
            vim.cmd('NnnPicker ' .. selection.value)
          end)
          return true
        end,
      }):find()
    end,
  },
}
