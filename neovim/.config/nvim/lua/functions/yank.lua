local yank = {}

yank.file = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local contents = table.concat(lines, '\n')
    vim.fn.setreg('+', contents)

    -- just for the highlight effect
    vim.cmd('silent normal mygg"yyG`y')

    print("File copied to clipboard")
end

yank.relative_path = function()
    local path = vim.api.nvim_buf_get_name(0)
    vim.fn.setreg('+', path)
    print('Relative path copied to clipboard')
end

yank.full_path = function()
    local path = vim.fn.expand('%:p')
    vim.fn.setreg('+', path)
    print('Full path copied to clipboard')
end

yank.remove_hard_line_breaks = function()
    local lines = vim.fn.getreg('+', 1, 1)
    local merged_lines = {}
    local current_paragraph = {}

    for _, line in ipairs(lines) do
        if line == "" then
            if #current_paragraph > 0 then
                table.insert(merged_lines, table.concat(current_paragraph, " "))
                current_paragraph = {}
            end
            table.insert(merged_lines, "")
        else
            table.insert(current_paragraph, line)
            if line:sub(-1) == " "
                or line:match("^%s*[%*'+]")
                or line:match("^%s*[0-9]+%.") then
                table.insert(merged_lines, table.concat(current_paragraph, " "))
                current_paragraph = {}
            end
        end
    end

    if #current_paragraph > 0 then
        table.insert(merged_lines, table.concat(current_paragraph, " "))
    end

    vim.fn.setreg('+', table.concat(merged_lines, "\n"))
    print('Copied trimmed content')
end

yank.remove_leading_and_trailing_newlines = function()
    local content = vim.fn.getreg('+')
    local modified_content = content:gsub("^[\r\n]+", ""):gsub("[\r\n]+$", "")
    vim.fn.setreg('+', modified_content)
    print("Removed leading and trailing newlines from + register")
end

return yank
