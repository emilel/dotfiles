#!/bin/bash

[[ $(cat /sys/class/net/enp0s31f6/carrier) -gt 0 ]] && echo "ETH" || echo ""
