S = {}

S.mark = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.g.marked_highlight_id then
        vim.api.nvim_buf_clear_namespace(bufnr, -1, vim.g.marked_position[1][2] - 1, vim.g.marked_position[2][2])
    end

    vim.api.nvim_feedkeys('"yy', 'x', true)
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    vim.g.marked_position = { start_pos, end_pos }
    vim.g.marked_highlight_id = vim.api.nvim_buf_add_highlight(bufnr, -1, "Search", start_pos[2] - 1, start_pos[3] - 1,
        end_pos[3])
end

S.swap = function()
    if vim.g.marked_position == nil then
        print("No marked text to swap with")
        return
    end

    vim.api.nvim_feedkeys('"ud"yP', 'x', true)
    vim.fn.setpos("'<", vim.g.marked_position[1])
    vim.fn.setpos("'>", vim.g.marked_position[2])
    vim.cmd('normal! gv"up')
end

return S
