local navigate_hunks = function()
  local Job = require("plenary.job")
  require("telescope.pickers")
      .new({}, {
        prompt_title = "Git Hunks",
        finder = require("telescope.finders").new_table({
          results = Job:new({ command = "git", args = { "jump", "--stdout", "diff" } }):sync(),
          entry_maker = function(line)
            local filename, lnum_string, rest = line:match("([^:]+):(%d+):(.*)")
            if not filename or filename:match("^/dev/null") then return nil end

            local lnum = tonumber(lnum_string)
            return {
              value = filename,
              ordinal = line,
              filename = filename,
              lnum = lnum,
              display = function(entry)
                local formatted_line = string.format("%s:%d:%s", entry.filename, entry.lnum, rest)
                local highlights = { { { 0, #entry.filename }, "Function" } }
                return formatted_line, highlights
              end,
            }
          end,
        }),
        sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
        previewer = require("telescope.config").values.grep_previewer({}),
        layout_strategy = "flex",
      })
      :find()
end

return {
  'lewis6991/gitsigns.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  keys = {
    { '<c-g>s', function() require('gitsigns').stage_hunk() end,                                       desc = 'Stage hunk' },
    { '<c-g>s', function() require('gitsigns').stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,  mode = 'x',               desc = 'Stage hunk' },
    { '<c-g>u', function() require('gitsigns').undo_stage_hunk() end,                                  desc = 'Undo hunk' },
    { '<c-g>x', function() require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = 'Reset hunk' },
    { '<c-g>x', function() require('gitsigns').reset_hunk() end,                                       mode = 'x',               desc = 'Reset hunk' },
    { '<c-g>p', function() require('gitsigns').preview_hunk() end,                                     desc = 'Preview hunk' },
    { '<c-g>t', function() require('gitsigns').toggle_deleted() end,                                   desc = 'Toggle deleted' },
    { '<c-g>h', navigate_hunks,                                                                        desc = 'Navigate hunks' },
    { '<c-g>m', '<cmd>silent !git checkout master -- %<cr>',                                           desc = 'Revert to master' },
    { ']h', function() require('gitsigns').nav_hunk('next') end, desc = 'Next hunk' },
    { '[h', function() require('gitsigns').nav_hunk('prev') end, desc = 'Previous hunk' },
  },
  lazy = false,
  opts = {
    sign_priority = 11,
  },
}
