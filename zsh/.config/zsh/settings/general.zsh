#!/bin/zsh

# use neovim as default
export EDITOR=nvim
export MANPAGER='nvim +Man!'

# Where Arbuscular's dev account gets its provider key back from after a
# database rebuild. The snapshot keeps hashes and never a secret, so this
# file is the only thing that refiles the key -- unset, a rebuild leaves
# the account signed in and unable to reach a model.
export PROVIDER_KEY_FILE="$HOME/dotfiles/secrets/openrouter.env"
