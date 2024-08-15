ensure_cloned() {
    local username="$1"
    local repo_name="$2"
    local repo_dir="$HOME/.zsh/$repo_name"

    if [[ ! -d "$repo_dir" ]]; then
        git clone "http://github.com/$username/$repo_name" "$repo_dir"
    fi
}

source_repo() {
    local repo_name="$1"
    local repo_dir="$HOME/.zsh/$repo_name"

    if [[ -f "$repo_dir/$repo_name.zsh" ]]; then
        source "$repo_dir/$repo_name.zsh"
    else
        echo "error sourcing $repo_name"
    fi
}


# syntax highlighting
ensure_cloned zsh-users zsh-syntax-highlighting
source_repo zsh-syntax-highlighting

# use system clipboard
ensure_cloned kutsan zsh-system-clipboard
source_repo zsh-system-clipboard

# theme
ensure_cloned sindresorhus pure
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure
