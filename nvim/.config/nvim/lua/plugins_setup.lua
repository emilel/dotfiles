-- HELPERS
local nmap = require('helpers').nmap
local imap = require('helpers').imap
local vmap = require('helpers').vmap

-- TELESCOPE

require('telescope').setup {
    pickers = {
        find_files = {
            hidden = true
        },
        live_grep = {
            additional_args = function(opts)
                return {"--hidden"}
            end
        },
    },
    defaults = {
        file_ignore_patterns = {
            ".git",
            "%.png",
            "%.pdf",
            "%.pt",
            "%.pickle",
        },
        layout_strategy = "vertical",
        mappings = {
            i = {
                ["<C-q>"] = require("telescope.actions").send_to_qflist,
            },
        },
    }
}

-- find file
nmap('<space>a', '<cmd>Telescope find_files<cr>')

-- find buffer
nmap('<space>s', '<cmd>Telescope buffers<cr>')

-- find text
nmap('<space>/', '<cmd>Telescope live_grep<cr>')

-- find selected text
vmap('<space>/', '"hy:lua require("telescope.builtin").grep_string({ additional_args = function(opts) return {"--hidden"} end })<cr><c-r>h')
vmap('<space>?', '"hy:lua require("telescope.builtin").grep_string({ additional_args = function(opts) return {"--hidden"} end })<cr>function <c-r>h')
-- vmap('<space>/', '"hy<cmd>Telescope live_grep<cr><c-r>h')


-- TREESITTER

-- enable folding via treesitter
vim.opt.foldmethod='expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel=99

require('nvim-treesitter.configs').setup {
    incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = ",v",
          node_incremental = ".",
          scope_incremental = ",",
          node_decremental = "-",
        },
    },
    highlight = {
      enable = true,
    },
    indent = {
        -- fuck
      enable = false,
    },
    textobjects = {
        swap = {
            enable = true,
            swap_next = {
              [",>"] = "@parameter.inner",
            },
            swap_previous = {
              [",<"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [",j"] = "@function.outer",
              -- [",j"] = "@class.outer",
            },
            goto_next_end = {
              [",J"] = "@function.outer",
              -- [",J"] = "@class.outer",
            },
            goto_previous_start = {
              [",k"] = "@function.outer",
              -- [",k"] = "@class.outer",
            },
            goto_previous_end = {
              [",K"] = "@function.outer",
              -- [",K"] = "@class.outer",
              },
        },
        lsp_interop = {
            enable = true,
            border = 'none',
            peek_definition_code = {
              [",Df"] = "@function.outer",
              [",DF"] = "@class.outer",
            },
        },
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@call.outer",
              ["ic"] = "@call.inner",
              ["ao"] = "@comment.outer",
              ["io"] = "@comment.inner",
              ["ad"] = "@statement.outer",
              ["an"] = "@conditional.outer",
              ["in"] = "@conditional.inner",
          },
        },
    },
}

-- VIM-COMMENTARY

-- paste block above or below
nmap('gcP', 'muP`[v`]gc`u', { noremap = false, silent = true })
nmap('gcp', 'mup`[v`]gc`u', { noremap = false, silent = true })

-- UNDOTREE

nmap('<space>u', '<cmd>UndotreeToggle<cr>')

--- NNN

-- open folder of current file
nmap('-', '<cmd>NnnPicker %:p:h<cr>')

-- open home folder
nmap('_', '<cmd>NnnPicker<cr>')

-- don't use default mappings
vim.g["nnn#set_default_mappings"] = 0

-- size
vim.g["nnn#layout"] = { window = { width = 0.8, height = 0.80 } }

-- don't rollover
vim.g["nnn#command"] = 'nnn -R'

-- NVIM-CMP
local cmp = require'cmp'
cmp.setup({
mapping = {
  ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
  ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
  ['<C-u>'] = cmp.mapping.scroll_docs(-4),
  ['<C-d>'] = cmp.mapping.scroll_docs(4),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
},
sources = {
  { name = 'nvim_lsp' },
}
})
