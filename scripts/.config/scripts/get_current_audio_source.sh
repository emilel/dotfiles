#!/bin/zsh -f

source=$(wpctl status | awk '/Audio/{flag=1} /Video/{flag=0} flag' | awk '/Sources/{flag=1; next} /├─/{flag=0} flag' | awk '/\*/{sub(" │  \\*   ", ""); sub("\\..*", ""); print $1}')
nick=$(wpctl inspect $source | grep -Po 'node.nick = "\K[^"]+')
echo $nick
