#!/bin/bash

set -e

tmux new-session sh -c "tmconfsetup.sh && zsh"
