source_files_in_folder() {
    local folder="$1"

    if [ -d $folder ]; then
        local current_file="$0"
        local files=("$folder"/**/*.zsh)

        for file in ${files[@]}; do
            if [ -f $file ] && [ "$file" != $current_file ] && [ $(basename $file) != ".history.zsh" ] ; then
                source "$file"
            fi
        done
    fi
}

source_files_in_folder "$HOME/.config/zsh"
source_files_in_folder "$HOME/.secret"
source "$HOME/.config/scripts/init_aliases.sh"
