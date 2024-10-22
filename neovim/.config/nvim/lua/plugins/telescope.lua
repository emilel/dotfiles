local function go_to_directory()
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local previewers = require('telescope.previewers')

  pickers.new({}, {
    prompt_title = "Find Folders",
    finder = finders.new_oneshot_job({ "fd", "--type", "d", "--hidden", "--exclude", ".git" }, {}),
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_termopen_previewer({
      get_command = function(entry)
        return { 'tree', '-L', '1', entry[1] }
      end
    }),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd('NnnPicker ' .. vim.fn.fnameescape(selection[1]))
        vim.defer_fn(function()
          vim.cmd('startinsert')
        end, 100)
      end)
      return true
    end,
  }):find()
end


return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    "nvim-telescope/telescope-live-grep-args.nvim",
    "danielfalk/smart-open.nvim",
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope-fzy-native.nvim"
  },
  keys = {
    {
      '<space>f',
      function() require('telescope').extensions.smart_open.smart_open() end,
      desc = 'Find files'
    },
    {
      '<space>/',
      function() require('telescope').extensions.live_grep_args.live_grep_args() end,
      desc = 'Grep all files'
    },
    {
      '<space>*',
      function()
        require("telescope-live-grep-args.shortcuts").grep_visual_selection()
      end,
      desc = 'Search for selected string in current working directory',
      mode = 'x'
    },
    {
      '<space>*',
      function()
        require("telescope-live-grep-args.shortcuts").grep_word_under_cursor()
      end,
      desc = 'Search for current word in current working directory',
    },
    {
      '<space>t',
      function() require('telescope.builtin').resume() end,
      desc =
      'Resume telescope'
    },
    {
      '<space>m',
      function() require('telescope.builtin').keymaps() end,
      desc =
      'Show mappings'
    },
    {
      '<space>g',
      go_to_directory,
      desc = 'Go to directory'
    },
    {
      '<space>s',
      function() require('telescope.builtin').lsp_document_symbols({ symbol_width = 50 }) end,
      desc = 'LSP document symbols'
    },
    {
      '<space>S',
      require('telescope.builtin').lsp_workspace_symbols,
      desc = 'Search for workspace symbols'
    }
  },
  config = function()
    local telescope = require('telescope')
    local lga_actions = require("telescope-live-grep-args.actions")

    telescope.setup({
      defaults = {
        layout_strategy = 'vertical',
        layout_config = {
          vertical = {
            preview_cutoff = 30,
          }
        },
        mappings = {
          i = {
            ['<esc>'] = require('telescope.actions').close,
            ['<c-j>'] = require('telescope.actions').move_selection_next,
            ['<c-k>'] = require('telescope.actions').move_selection_previous,
            ['<c-q>'] = require('telescope.actions').smart_send_to_qflist,
            ['<c-space>'] = require('telescope.actions').toggle_selection,
            ['<c-x>'] = require('telescope.actions').delete_buffer,
          }
        }
      },
      pickers = {
        find_files = {
          hidden = true,
          file_ignore_patterns = { "^%.git/", "%.pt$" }
        },
        live_grep = {
          additional_args = function(_)
            return { "--hidden" }
          end,
          file_ignore_patterns = { "^%.git/" }
        },
        grep_string = {
          additional_args = function(_)
            return { "--hidden" }
          end,
        },
        buffers = {
          sort_lastused = true,
          ignore_current_buffer = false,
          file_ignore_patterns = { "^fugitive://" },
          sort_mru = true
        }
      },
      extensions = {
        live_grep_args = {
          additional_args = function(_)
            return { "--hidden", "--smart-case" }
          end,
          file_ignore_patterns = { "^%.git/" },
          mappings = {
            i = {
              ["<C-'>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              ["<C-t>"] = lga_actions.quote_prompt({ postfix = " -t " }),
            }
          }
        },
        smart_open = {
          hidden = true,
          file_ignore_patterns = { "^%.git/", "%.pt$" },
          cwd_only = true,
        }
      }
    })

    telescope.load_extension("live_grep_args")
    telescope.load_extension("smart_open")
  end,
  lazy = true
}
