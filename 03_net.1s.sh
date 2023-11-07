#!/usr/bin/bash

convert_size() {
  local size_in_bytes=$1

  if (( size_in_bytes >= 1000000 )); then
    printf "%.2f MBs" "$(bc -l <<< "$size_in_bytes/1000000")"
  else
    printf "%.2f KBs" "$(bc -l <<< "$size_in_bytes/1000")"
  fi
}

function padded {
    local str="$1"
    local len="$2"
    local num=${str%% *}
    local unit=${str#* }
    printf "%*s %s" "$len" "$num" "$unit"
}

# # Detect which network interface is active
network_interface=$(ip route get 8.8.8.8 | awk '{print $5}')

net_stat_dir="$HOME/.local/argos/sys_monitor/$network_interface"
mkdir -p "$net_stat_dir"

# Get RX TX bytes
cur_rx_bytes=$(cat /sys/class/net/"$network_interface"/statistics/rx_bytes)
cur_tx_bytes=$(cat /sys/class/net/"$network_interface"/statistics/tx_bytes)
prev_rx_bytes=$(cat $net_stat_dir/rx_bytes || echo "$cur_rx_bytes")
prev_tx_bytes=$(cat $net_stat_dir/tx_bytes || echo "$cur_tx_bytes")
echo "$cur_rx_bytes" > "$net_stat_dir/rx_bytes"
echo "$cur_tx_bytes" > "$net_stat_dir/tx_bytes"

# RX rate
rx_rate=$(echo "$cur_rx_bytes - $prev_rx_bytes" | bc)
rx_rate_human=$(convert_size "$rx_rate")
padded_rx_rate_human=$(padded "$rx_rate_human" 6)
# TX rate
tx_rate=$(echo "$cur_tx_bytes - $prev_tx_bytes" | bc)
tx_rate_human=$(convert_size "$tx_rate")
padded_tx_rate_human=$(padded "$tx_rate_human" 6)
echo "⏷ $padded_rx_rate_human ⏶ $padded_tx_rate_human | size=9px font=monospace"
