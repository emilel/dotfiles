# use pure theme

autoload -U promptinit; promptinit
prompt pure

# enable syntax highlighting

local syntax_highlighting_file="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if [ -f $syntax_highlighting_file ]; then
    source $syntax_highlighting_file
fi

# don't print virtual environment

export VIRTUAL_ENV_DISABLE_PROMPT=1
