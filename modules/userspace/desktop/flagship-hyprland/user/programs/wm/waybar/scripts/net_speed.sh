#!/usr/bin/env bash

STATE="/tmp/.netspeed-${IFACE}.tmp"
TEST_ENDPOINT="1.1.1.1"

# Read old values if file exists
if [[ -f "$STATE" ]]; then
    read IFACE IFACE_NO RX_OLD TX_OLD TIME_OLD < "$STATE"

    if (( IFACE_NO >= 50 )); then
	IFACE=$(ip route get $TEST_ENDPOINT | awk '{print $3}' | head -1)
	IFACE_NO=0
    fi

    RX_NOW=$(cat /sys/class/net/${IFACE}/statistics/rx_bytes)
    TX_NOW=$(cat /sys/class/net/${IFACE}/statistics/tx_bytes)

    TIME_NOW=$(date +%s)
    TIME_DIFF=$((TIME_NOW - TIME_OLD))

    RX_DIFF=$((RX_NOW - RX_OLD))
    TX_DIFF=$((TX_NOW - TX_OLD))

    if (( TIME_DIFF > 0 )); then
        RX_RATE=$((RX_DIFF / TIME_DIFF))
        TX_RATE=$((TX_DIFF / TIME_DIFF))
    else
        RX_RATE=0
        TX_RATE=0
    fi
else
    RX_RATE=0
    TX_RATE=0
    IFACE=""
    IFACE_NO=0
    while [ -z "$IFACE" ]; do
        IFACE=$(ip route get $TEST_ENDPOINT | awk '{print $3}' | head -1)
	[ -z "$IFACE" ] && sleep 1
    done
fi

((IFACE_NO++))

# Save new state
echo "$IFACE $IFACE_NO $RX_NOW $TX_NOW $TIME_NOW" > "$STATE"

# Function to humanize bytes
human() {
    local bytes=$1
    if (( bytes < 1024 )); then echo "${bytes}B/s"
    elif (( bytes < 1048576 )); then echo "$((bytes / 1024))KB/s"
    else echo "$((bytes / 1048576))MB/s"; fi
}

# Output JSON for Waybar
echo "{\"text\": \" $(human $RX_RATE)  $(human $TX_RATE)\", \"tooltip\": \"Network speed on $IFACE\"}"
