#!/bin/zsh

echo ${(j:, :)$(tmux list-sessions -F '#{session_name}')}
