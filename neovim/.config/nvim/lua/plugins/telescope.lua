local strings = require('functions.strings')

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
        vim.cmd('Oil ' .. vim.fn.fnameescape(selection[1]))
      end)
      return true
    end,
  }):find()
end

local function paste_text(new_line)
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local previewers = require('telescope.previewers')

  local paste_dir = vim.fn.expand('~/.setup/paste/')
  local files = vim.fn.readdir(paste_dir)

  pickers.new({}, {
    prompt_title = "Paste Text",
    finder = finders.new_table({
      results = files,
    }),
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_buffer_previewer({
      define_preview = function(self, entry)
        local filepath = paste_dir .. entry.value
        local lines = vim.fn.readfile(filepath)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
      end,
    }),
    attach_mappings = function(prompt_bufnr, _)
      local function multi_select_paste()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local selections = picker:get_multi_selection()
        if vim.tbl_isempty(selections) then
          table.insert(selections, action_state.get_selected_entry())
        end
        actions.close(prompt_bufnr)

        local combined_lines = {}
        for _, selection in ipairs(selections) do
          local filepath = paste_dir .. selection.value
          local lines = vim.fn.readfile(filepath)

          -- Trim leading/trailing whitespace for each line
          for i, line in ipairs(lines) do
            lines[i] = vim.trim(line)
          end

          -- Concatenate the lines into one string
          table.insert(combined_lines, table.concat(lines, "\n"))
        end

        local content
        if new_line then
          content = table.concat(combined_lines, "\n")
        else
          content = table.concat(combined_lines, " "):gsub("^%s+", "") -- Remove leading spaces
        end

        local regtype = new_line and 'l' or 'v'
        vim.fn.setreg('"', content, regtype)

        -- Paste after the cursor using `p`
        vim.api.nvim_command('normal! h')
        vim.api.nvim_command('normal! ""p')

        -- Ensure no extra leading space in inline paste
        if not new_line then
          -- Remove leading space manually if it still exists
          vim.cmd([[execute "normal! \<Right>"]])
        end
      end

      actions.select_default:replace(multi_select_paste)

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
      '<space>a',
      function() require('telescope.builtin').buffers() end,
      desc = 'Find files'
    },
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
      '<c-g>/',
      function()
        local git_diff_files = vim.fn.systemlist("git diff --name-only")
        require('telescope.builtin').live_grep {
          search_dirs = git_diff_files,
          prompt_title = "Grep in Git Diff Files"
        }
      end,
      desc = 'Grep in git diff files'
    },
    {
      '<c-g>a',
      function()
        local git_diff_files = vim.fn.systemlist(
          "git diff --name-only && git diff --name-only --cached && git ls-files --others --exclude-standard"
        )

        local file_set = {}
        for _, file in ipairs(git_diff_files) do
          file_set[file] = true
        end
        local unique_files = vim.tbl_keys(file_set)

        if vim.tbl_isempty(unique_files) then
          print("No changes to search!")
          return
        end

        require('telescope.builtin').find_files {
          prompt_title = "Git Diff Files",
          search_dirs = unique_files,
        }
      end,
      desc = 'Find files in git diff',
    },
    {
      '<space>*',
      function()
        vim.cmd('normal! "yy')
        local search_term = vim.fn.getreg('y')
        local esaped_search_term = strings.escape_pcre(search_term)
        require('telescope').extensions.live_grep_args.live_grep_args({ default_text = esaped_search_term })
      end,
      desc = 'Search for selected string in current working directory',
      mode = 'x'
    },
    {
      '<space>*',
      function()
        local search_term = '\\<' .. vim.fn.expand('<cword>') .. '\\>'
        require('telescope').extensions.live_grep_args.live_grep_args({ default_text = search_term })
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
    },
    {
      '<space>f',
      function()
        vim.cmd('normal! "yy')
        local selected_text = vim.fn.getreg('y')
        require('telescope').extensions.smart_open.smart_open({ default_text = selected_text })
      end,
      desc = 'Find file',
      mode = 'x'
    },
    {
      '<space>n/',
      function()
        local file_name = strings.get_file_name()
        require('telescope').extensions.live_grep_args.live_grep_args({ default_text = file_name })
      end,
      desc = 'Find references to file',
    },
    {
      '<space>p',
      function() paste_text(false) end,
      desc = 'Paste text',
    },
    {
      '<space>P',
      function() paste_text(true) end,
      desc = 'Paste text on new line',
    },
  },
  config = function()
    local telescope = require('telescope')
    local lga_actions = require("telescope-live-grep-args.actions")

    telescope.setup({
      defaults = {
        path_display = function(_, path)
          local tail = require("telescope.utils").path_tail(path)
          local directory = path:match("(.*/)") or "./"
          local formatted_path = string.format("%s %s", tail, directory)
          local path_start = #tail + 1
          local highlights = {
            {
              {
                path_start,
                #formatted_path,
              },
              "Function",
            },
          }

          return formatted_path, highlights
        end,
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
