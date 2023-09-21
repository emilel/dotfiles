function activate_plugin() {
    local git_url=$1
    local file_name=$2
    local repo_name=$(basename -s .git "$git_url")
    local plugin_dir="/usr/share/zsh/plugins/$repo_name"

    if [ ! -d "$plugin_dir" ]; then
        sudo git clone "$git_url" "$plugin_dir"
    fi

    source "$plugin_dir/$file_name"
}

activate_plugin https://github.com/zsh-users/zsh-autosuggestions.git zsh-autosuggestions.zsh
