#!/usr/bin/bash
# cpu usage in percent

function padded {
    local str="$1"
    local len="$2"
    echo "$str" | awk '{printf "%*s", '$len', $1}'
}

cpu_idle=$(mpstat 1 1 -o JSON | jq '.sysstat.hosts[0].statistics[0]."cpu-load"[0].idle')
cpu_usage=$(echo "100 - $cpu_idle" | bc)
rounded_cpu_usage=$(printf "%.0f" $cpu_usage)
padded_cpu_usage=$(padded $rounded_cpu_usage 3)
echo "cpu $padded_cpu_usage% | size=9px font=monospace"
