local globals = require('globals')

-- # general

-- ## show number column

vim.opt.number = true

-- ## don't have the line all the way up/down

vim.opt.scrolloff = 8

-- ## show sign column

vim.opt.signcolumn = 'yes'

-- ## set textwidth

vim.opt.textwidth = 80

-- ## use system clipboard

vim.opt.clipboard = "unnamedplus"

-- # indentation

-- ## use spaces instead of tabs

vim.opt.expandtab = true

-- ## indentation level

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- ## don't hide things

vim.opt.conceallevel = 0

-- ## use undo files instead of swap files

vim.opt.swapfile = false
vim.opt.undofile = true

-- # format options

-- c: autowrap comments inserting the current comment leader
-- r: insert current comment leader after <cr> in insert mode
-- q: allow comment formatting
-- a: automatic formatting of paragraphs (only for recognized comments)
-- n: recognize lists and use the indentation of the first line for the rest
-- j: remove comment leader when joining lines

vim.opt.formatoptions = globals.formatoptions

-- # search

-- ## ignore case

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- # terminal mode

-- ## start in insert mode

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
    desc = 'Set terminal to insert mode',
    group = vim.api.nvim_create_augroup("enter_terminal", { clear = true }),
    pattern = 'term://*',
    callback = function()
        vim.schedule(function()
            vim.cmd(':startinsert')
        end)
    end,
})

-- # startup

-- ## ignore the empty buffer

local function check_and_delete_empty_buffer()
    local buffers = vim.api.nvim_list_bufs()
    local non_empty_buffers = 0
    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.fn.bufname(buf) ~= "" then
            non_empty_buffers = non_empty_buffers + 1
        end
    end
    if non_empty_buffers == 1 and vim.fn.bufname("%") == "" then
        vim.api.nvim_command("bd")
    end
end

vim.api.nvim_create_autocmd(
    { 'BufNewFile' },
    {
        group = vim.api.nvim_create_augroup('buffer_cleanup', { clear = true }),
        callback = check_and_delete_empty_buffer
    }
)

vim.api.nvim_create_autocmd(
    { 'BufAdd' },
    {
        group = vim.api.nvim_create_augroup('buffer_cleanup', { clear = true }),
        callback = check_and_delete_empty_buffer
    }
)

vim.api.nvim_create_autocmd(
    'VimEnter',
    {
        group = vim.api.nvim_create_augroup('startup', { clear = true }),
        callback = function()
            vim.defer_fn(function()
                if vim.fn.expand('%') ~= '' or (vim.fn.line('$') > 1 and vim.fn.line2byte(1) ~= -1) then
                    return
                end

                for _, arg in ipairs(vim.v.argv) do
                    if string.match(arg, "^%-c") or string.match(arg, "^%+") then
                        return
                    end
                end

                local jumps = vim.fn.getjumplist()[1]
                local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':p')

                local count = #jumps
                for i = count, 1, -1 do
                    local jump = jumps[i]
                    local buffer_name = vim.fn.fnamemodify(vim.fn.bufname(jump.bufnr), ':p')

                    if string.sub(buffer_name, 1, #cwd) == cwd then
                        vim.cmd(string.format("edit %s", buffer_name))
                        vim.api.nvim_win_set_cursor(0, { jump.lnum, jump.col })
                        return
                    end
                end
            end, 0)
        end
    }
)
