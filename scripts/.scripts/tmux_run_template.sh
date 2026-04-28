#!/bin/bash

session=$(ls "$HOME/.tmux_templates" | fzf)

"$HOME/.tmux_templates/$session"
