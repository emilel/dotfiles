local function show_file_or_cwd_in_nnn_buffer(directory)
    directory = directory or vim.fn.getcwd()
    local bufname = vim.fn.bufname()
    if bufname ~= "" and bufname ~= nil then
        vim.cmd('let g:nnn#command="nnn -w ' ..
            vim.fn.expand("%:t") .. '" | let g:nnn#layout = "enew" | NnnPicker %:p:h')
    else
        vim.api.nvim_command('NnnPicker ' .. directory)
    end
end

local function show_file_or_cwd_in_nnn_sidebar()
    local bufname = vim.fn.bufname()
    if bufname ~= "" and bufname ~= nil then
        vim.cmd('let g:nnn#command="nnn -w ' ..
            vim.fn.expand("%:t") .. '" | let g:nnn#layout = { "left": "35" } | NnnPicker %:p:h')
    else
        vim.cmd('NnnPicker ' .. vim.fn.getcwd())
    end
end

local function go_to_directory(opts)
    local finders = require 'telescope.finders'
    local pickers = require 'telescope.pickers'
    local conf = require 'telescope.config'.values
    print('hello')
    opts = opts or {}

    pickers.new(opts, {
        prompt_title = 'Go to directory',
        finder = finders.new_oneshot_job(
            { 'fd', '-td', '--hidden', '--exclude', '.git' },
            opts
        ),
        sorter = conf.file_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
                local entry = require 'telescope.actions.state'.get_selected_entry()
                require 'telescope.actions'.close(prompt_bufnr)
                vim.cmd('let g:nnn#layout = "enew" | NnnPicker ' .. entry.value)
                vim.opt_local.list = false
            end)
            return true
        end,
    }):find()
end

vim.api.nvim_create_autocmd(
    'VimEnter',
    {
        group = vim.api.nvim_create_augroup('nnn', { clear = true }),
        callback = function()
            vim.cmd([[silent! autocmd! FileExplorer *]])
            if vim.fn.isdirectory(vim.fn.expand('%')) == 1 then
                vim.cmd('let g:nnn#command="nnn -w ' ..
                    vim.fn.expand("%:t") .. '" | let g:nnn#layout = "enew" | NnnPicker %')
            end
        end
    }
)

return {
    'mcchrish/nnn.vim',
    cmd = { 'NnnPicker' },
    keys = {
        {
            '_',
            show_file_or_cwd_in_nnn_buffer,
            desc = 'Open file picker buffer'
        },
        {
            '-',
            show_file_or_cwd_in_nnn_sidebar,
            desc = 'Open file picker sidebar'
        },
        {
            '<space>g',
            go_to_directory,
            desc = 'Go to directory'
        }
    },
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
        require('nnn').setup({
            set_default_mappings = false,
            layout = ''
        })
    end
}
