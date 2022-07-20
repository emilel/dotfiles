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

-- find marks
nmap('<space>s', '<cmd>Telescope buffers<cr>')

-- find text
nmap('<space>/', '<cmd>Telescope live_grep<cr>')

-- find selected text
-- vmap('<space>/', '"hy:lua require("telescope.builtin").grep_string({ additional_args = function(opts) return {"--hidden"} end })<cr><c-r>h')
-- vmap('<space>?', '"hy:lua require("telescope.builtin").grep_string({ additional_args = function(opts) return {"--hidden"} end })<cr>function <c-r>h')
-- vmap('<space>/', '"hy<cmd>Telescope live_grep<cr><c-r>h')
vmap('<space>/', '"hy:Telescope live_grep<cr><c-r>h')


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
          node_decremental = ",",
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
              [",u"] = "@class.outer",
            },
            goto_next_end = {
              [",J"] = "@function.outer",
              [",U"] = "@class.outer",
            },
            goto_previous_start = {
              [",k"] = "@function.outer",
              [",i"] = "@class.outer",
            },
            goto_previous_end = {
              [",K"] = "@function.outer",
              [",I"] = "@class.outer",
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
              ["al"] = "@block.outer",
              ["il"] = "@block.inner",
              ["a,"] = "@parameter.outer",
              ["i,"] = "@parameter.inner",
          },
        },
    },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        colors = {'#ebdbb2', '#fe8019', '#83a598', '#fabd2f', '#b8bb26'}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
      }
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
-- nmap('_', '<cmd>NnnPicker<cr>')

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
  ['<down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
  ['<up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
  ['<C-u>'] = cmp.mapping.scroll_docs(-4),
  ['<C-d>'] = cmp.mapping.scroll_docs(4),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
},
sources = {
  { name = 'nvim_lsp' },
}
})

-- INDENTLINE
-- -- keep conceallevel
vim.g.indentLine_setConceal = 0

-- indent character
vim.g.indentLine_char = '▏'

-- TELESCOPE

-- add mark
nmap('<space>\'', '<cmd>lua require("harpoon.mark").add_file()<cr>')

-- open marks
nmap('<space>;', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>')

-- -- open commands
-- nmap('<space>l', '<cmd>lua require("harpoon.cmd-ui").toggle_quick_menu()<cr>()')

-- previous or next mark
nmap('<c-j>', '<cmd>lua require("harpoon.ui").nav_next()<cr>()')
nmap('<c-k>', '<cmd>lua require("harpoon.ui").nav_prev()<cr>()')

-- go to file
nmap('<space>1', '<cmd>lua require("harpoon.ui").nav_file(1)')
nmap('<space>2', '<cmd>lua require("harpoon.ui").nav_file(2)')
nmap('<space>3', '<cmd>lua require("harpoon.ui").nav_file(3)')

-- SURROUND
vim.g.surround_no_mappings = 1
vmap('s', '<Plug>VSurround')
nmap('ds', '<plug>Dsurround')
nmap('cs', '<plug>Csurround')
nmap('cS', '<plug>CSurround')
nmap('ys', '<plug>Ysurround')
nmap('yS', '<plug>YSurround')
nmap('yss', '<plug>Yssurround')
nmap('ySs', '<plug>YSsurround')
nmap('ySS', '<plug>YSSurround')

-- VISUAL STAR
-- vim.cmd([[vnoremap / :<C-u>call VisualStarSearchSet('/')<CR>:execute 'noautocmd vimgrep /' . @/ . '/ **'<CR>]])

-- LIGHTSPEED
nmap('|', '<Plug>Lightspeed_s')
nmap('_', '<Plug>Lightspeed_S')
require'lightspeed'.opts.ignore_case = true

-- REFACTOR
require("telescope").load_extension("refactoring")
vmap(',e', '<cmd>lua require("refactoring").refactor("Extract Function")<cr>')
vmap(',E', '<cmd>lua require("telescope").extensions.refactoring.refactors()<cr>')
nmap(',E', '<cmd>lua require("telescope").extensions.refactoring.refactors()<cr>')

-- SLIME
vim.g.slime_target = "tmux"
vim.g.slime_no_mappings = 1
vim.g.slime_default_config = {socket_name='default', target_pane=":repl"}
nmap('<space>L', '<Plug>SlimeConfig')
