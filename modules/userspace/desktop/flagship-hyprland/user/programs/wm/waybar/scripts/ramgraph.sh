#!/usr/bin/env bash

HISTORY_LENGTH=10  # Number of data points for the graph
GRAPH_CHARS=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")  # Unicode bar characters

# Initialize history array
declare -a history
for ((i=0; i<HISTORY_LENGTH; i++)); do history[i]="0"; done

while true; do
  # Get current RAM usage percentage
  ram_percent=$(free -m | awk '/Mem:/ {printf "%.0f", $3/$2*100}')
  
  # Update history (shift left, add new value)
  history=("${history[@]:1}" "$ram_percent")
  
  # Generate graph
  graph=""
  for perc in "${history[@]}"; do
    index=$(( (perc * ${#GRAPH_CHARS[@]}) / 100 ))
    [[ $index -ge ${#GRAPH_CHARS[@]} ]] && index=$((${#GRAPH_CHARS[@]}-1))
    graph+="${GRAPH_CHARS[$index]}"
  done

  # Output JSON for Waybar
  echo "{\"text\":\"$graph $ram_percent%\", \"tooltip\":\"RAM History: ${history[*]}%\"}"
  
  sleep 2  # Update interval (seconds)
done
