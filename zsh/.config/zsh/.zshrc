#/bin/zsh

source_directory() {
    local directory="$1"
    local files=("$directory"/**/*.zsh(N))

    for file in ${files[@]}; do
        if [ -f $file ] ; then
            source "$file"
        fi
    done
}

ZSH_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

source_directory "$ZSH_DIR/programs"
source_directory "$ZSH_DIR/settings"
source_directory "$ZSH_DIR/commands"
source_directory "$HOME/.setup"

source "$ZSH_DIR/plugins.zsh"
