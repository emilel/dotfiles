ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Ubuntu's /etc/zsh/zshrc runs its own compinit before this ZDOTDIR's .zshrc is
# read, dumping into $ZDOTDIR and costing ~45ms per shell. settings/behavior.zsh
# runs compinit after it and wins anyway, so skip the duplicate.
skip_global_compinit=1
