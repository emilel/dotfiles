return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<space>f',
      function() require('telescope.builtin').find_files() end,
      desc = 'Find files'
    },
    {
      '<space>/',
      function() require('telescope.builtin').live_grep() end,
      desc = 'Grep all files'
    },
    {
      '<space>a',
      function()
        require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = false })
      end,
      desc = 'Go to buffer'
    },
    {
      '<space>*',
      function()
        vim.cmd('normal! "yy')
        local search_term = vim.fn.getreg('y')
        search_term = vim.fn.escape(search_term, '\\\\')
        require('telescope.builtin').grep_string({ search = search_term })
      end,
      desc = 'Search for selected string in current working directory',
      mode = 'x'
    },
    {
      '<space>t',
      function() require('telescope.builtin').resume() end,
      desc =
      'Resume telescope'
    }, {
    '<space>m',
    function() require('telescope.builtin').keymaps() end,
    desc =
    'Show mappings'
  },
  },
  config = function()
    require('telescope').setup({
      defaults = {
        layout_strategy = 'vertical',
        mappings = {
          i = {
            ['<esc>'] = require('telescope.actions').close,
            ['<c-j>'] = require('telescope.actions').move_selection_next,
            ['<c-k>'] = require('telescope.actions').move_selection_previous,
            ["<c-x>"] = "delete_buffer"
          }
        }
      },
      pickers = {
        find_files = {
          hidden = true,
          file_ignore_patterns = { ".git" }
        },
        live_grep = {
          additional_args = function(_)
            return { "--hidden" }
          end,
          file_ignore_patterns = { ".git" }
        },
        grep_string = {
          additional_args = function(_)
            return { "--hidden" }
          end,
        }
      }
    })
  end,
  lazy = true
}
