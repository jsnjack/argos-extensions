#!/usr/bin/bash

function padded {
    local str="$1"
    local len="$2"
    echo "$str" | awk '{printf "%*s", '$len', $1}'
}

# memory usage in percent
mem_used=$(free -m | awk 'NR==2{printf "%d%%\n", $3*100/$2 }')
padded_mem_used=$(padded $mem_used 3)
echo "mem $padded_mem_used | size=9px font=monospace"
