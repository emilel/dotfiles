local helpers = require('functions.helpers')

local run = {}

run.send = function(command)
    if not helpers.run_window_exists() then
        print('No run window exists')
        return
    end

    if helpers.running() then
        print('An active command is already running')
        return
    end

    local buffer_name = vim.api.nvim_buf_get_name(0)
    local sanitized_command = string.gsub(command, '%%', buffer_name)

    local notify_running = "notify-send -t 0 'Running...'"
    local success_actions = "{ bell; makoctl dismiss -n 0; notify-send 'Finished running command!' }"
    local error_notification = "{ makoctl dismiss -n 0; notify-send 'Error sending command!' }"

    helpers.assure_no_copy_mode()
    if not helpers.empty() then
        helpers.clear_prompt()
    end

    local command_to_send = string.format(
        "%s && { %s; } && %s || %s",
        notify_running, sanitized_command, success_actions, error_notification
    )

    local tmux_command = string.format('tmux send-keys -t run "%s" Enter', command_to_send)
    io.popen(tmux_command)
end

run.interrupt = function()
    if not helpers.run_window_exists() then
        print('No run window exists')
        return
    end

    io.popen('tmux send-keys -t run ^C')
end

run.open = function(path)
    if path == nil then
        path = vim.api.nvim_buf_get_name(0)
    end
    vim.fn.system("tmux send-keys -t run 'handlr open " .. path .. "' Enter")
end

run.compile_letter = function()
    local role = vim.fn.input("Enter application role: ")
    if role == "" then
        return
    end
    run.send("compile_letter.sh % '" .. role .. "'")
end

run.open_compiled_letter = function()
    local pdf_file = string.gsub(vim.api.nvim_buf_get_name(0), 'letter.md', 'emil_eliasson-cover_letter.pdf')
    run.send("handlr open " .. pdf_file)
end

return run
