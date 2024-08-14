local F = {}

F.run_window_exists = function()
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

F.running = function()
    local handle = io.popen("tmux display-message -p -t run -F '#{pane_current_command}'")
    if not handle then
        print("Failed to execute command")
        return false
    end
    local result = handle:read("*a")
    handle:close()
    print(result)
    return result and result:gsub("%s+", "") ~= "zsh" and not result:match("^python")
end

F.empty = function()
    local handle = io.popen("tmux capture-pane -t run -p | tail -n1")
    if not handle then
        print("Failed to execute command")
        return false
    end
    local result = handle:read("*a")
    handle:close()
    return not (result and result:match("%w"))
end

F.clear_prompt = function()
    local tmux_command = 'tmux send-keys -t run C-c'
    io.popen(tmux_command)
end

F.assure_no_copy_mode = function()
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



return F
