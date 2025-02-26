#!/bin/zsh

alias lx='fd -ltx'

fdt() {
    fd -0 $1 $2 -HI | xargs -0 ls -lt
}
