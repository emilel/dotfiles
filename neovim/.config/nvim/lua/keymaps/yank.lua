-- copy file
vim.keymap.set('n', '<space>yf', 'gg0yG<c-o>', { desc = 'Copy entire file' })

-- copy relative path
vim.keymap.set('n', '<space>yp', function()
    local path = vim.fn.expand('%')
    vim.fn.setreg('+', path)
    print('Copied: ' .. path)
end, { desc = 'Copy relative path' })

-- copy full path
vim.keymap.set('n', '<space>yP', function()
    local path = vim.fn.expand('%:p')
    vim.fn.setreg('+', path)
    print('Copied: ' .. path)
end, { desc = 'Copy full path' })

-- copy file name
vim.keymap.set('n', '<space>yn', function()
    local path = vim.api.nvim_buf_get_name(0)
    local file_name = ""
    for part in path:gmatch("([^/]+)") do
        file_name = part
    end
    vim.fn.setreg('+', file_name)
    print('Copied: ' .. file_name)
end, { desc = 'Copy file name' })

-- copy branch name
vim.keymap.set('n', '<space>yb', function()
    local branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
    vim.fn.setreg('+', branch)
    print("Copied: " .. branch)
end, { desc = 'Copy branch name' })

-- copy repository, branch, file and line number
vim.keymap.set('n', '<space>yR',
    function()
        local repo_name = vim.fn.systemlist("basename `git rev-parse --show-toplevel`")[1]
        local branch_name = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
        local file_path = vim.fn.expand('%:~:.')
        local line_number = vim.fn.line('.')
        local repo_info = string.format("%s@%s %s:%d", repo_name, branch_name, file_path, line_number)
        vim.fn.setreg('+', repo_info)
        print("Copied: " .. repo_info)
    end, { desc = 'Copy repository, branch, file and line number' })

-- copy file and line number
vim.keymap.set('n', '<space>yl',
    function()
        local file_path = vim.fn.expand('%:~:.')
        local line_number = vim.fn.line('.')
        local repo_info = string.format("%s:%d", file_path, line_number)
        vim.fn.setreg('+', repo_info)
        print("Copied: " .. repo_info)
    end, { desc = 'Copy file and line number' })
