local function run_window_exists()
    local handle = io.popen("tmux list-windows -F '#W' | grep -w 'run'")
    if not handle then
        print("Failed to run tmux command")
        return false
    end

    local result = handle:read("*a")
    handle:close()
    if result then
        return result:gsub("%s+", "") ~= ""
    else
        return false
    end
end

local function running()
    local handle = io.popen("tmux display-message -p -t run -F '#{pane_current_command}'")
    if not handle then
        print("Failed to execute command")
        return false
    end
    local result = handle:read("*a")
    handle:close()
    return result and result:gsub("%s+", "") ~= "zsh"
end

local function empty()
    local handle = io.popen("tmux capture-pane -t run -p | tail -n1")
    if not handle then
        print("Failed to execute command")
        return false
    end
    local result = handle:read("*a")
    handle:close()
    return not (result and result:match("%w"))
end

local function clear_prompt()
    local tmux_command = 'tmux send-keys -t run C-c'
    io.popen(tmux_command)
end

local function assure_no_copy_mode()
    local handle = io.popen("tmux display-message -p -t run -F '#{pane_in_mode}'")
    if not handle then
        print("Failed to execute command")
        return false
    end
    local result = handle:read("*a")
    handle:close()

    if result and result:match("1") then
        io.popen("tmux send-keys -t run q")
    end
end


local run = {}

run.send = function(command)
    if not run_window_exists() then
        print('No run window exists')
        return
    end

    if running() then
        print('An active command is already running')
        return
    end

    local buffer_name = vim.api.nvim_buf_get_name(0)
    local sanitized_command = string.gsub(command, '%%', buffer_name)

    local notify_running = "notify-send -t 0 'Running...'"
    local success_actions = "{ bell; makoctl dismiss -n 0; notify-send 'Finished running command!' }"
    local error_notification = "{ makoctl dismiss -n 0; notify-send 'Error sending command!' }"

    assure_no_copy_mode()
    if not empty() then
        clear_prompt()
    end

    local command_to_send = string.format(
        "%s && { %s; } && %s || %s",
        notify_running, sanitized_command, success_actions, error_notification
    )

    local tmux_command = string.format('tmux send-keys -t run "%s" Enter', command_to_send)
    io.popen(tmux_command)
end

run.interrupt = function()
    if not run_window_exists() then
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
