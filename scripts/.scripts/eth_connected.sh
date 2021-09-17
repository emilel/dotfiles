#!/bin/bash

[[ $(cat /sys/class/net/enx1865717f95a9/carrier) -gt 0 ]] && echo "ETH" || echo ""
