#!/usr/bin/bash
# io utilization in percent

function padded {
    local str="$1"
    local len="$2"
    echo "$str" | awk '{printf "%*s", '$len', $1}'
}

hdd_usage=$(iostat -dxky 1 1 | kazy -i nvme0n1 | kazy -r -x "[\d.]*$")
rounded_hdd_usage=$(printf "%.0f" $hdd_usage)
padded_hdd_usage=$(padded $rounded_hdd_usage 3)
echo "io $padded_hdd_usage% | size=9px font=monospace"
