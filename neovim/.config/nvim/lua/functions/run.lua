local run = {}

run.send = function(command)
    local full_command = string.gsub(command, '%%', vim.api.nvim_buf_get_name(0))
    vim.fn.system("tmux send-keys -t run \"" .. full_command .. "\" Enter")
end

run.open = function(path)
    if path == nil then
        path = vim.api.nvim_buf_get_name(0)
    end
    vim.fn.system("tmux send-keys -t run 'handlr open " .. path .. "' Enter")
end

run.compile_letter = function ()
    local role = vim.fn.input("Enter application role: ")
    run.send("compile_letter.sh % '" .. role .. "'")
end

run.open_compiled_letter = function ()
    local pdf_file = string.gsub(vim.api.nvim_buf_get_name(0), 'letter.md', 'emil_eliasson-cover_letter.pdf')
    run.send("handlr open " .. pdf_file)
end

return run
