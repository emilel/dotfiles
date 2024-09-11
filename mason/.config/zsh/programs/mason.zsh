#!/bin/zsh

if [ -d "$HOME/.local/share/nvim/mason/bin" ]; then
    export PATH=$PATH:"$HOME/.local/share/nvim/mason/bin"
fi
