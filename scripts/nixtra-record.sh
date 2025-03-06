#!/usr/bin/env bash

which wf-recorder

pidf="$HOME/Videos/Screencasts/process.pid"
WF_RECORDER_OPTS=""
VIDEOEXT="mkv"

status() {
    if [ -f "$pidf" ]; then
        awk 'BEGIN{printf "{\"text\":\"\", \"tooltip\":\"Recording\\n"}
        NR==1{printf "PID: %s\\n", $0}
        NR==2{printf "Save to: %s\\n", $0}
        NR==3{printf "Log to: %s\"}", $0}' "$pidf"
    else
        echo '{"text":"", "tooltip":"Stopped"}'
    fi
}

toggle() {
    if [ -f "$pidf" ]; then
        read -r pid < "$pidf"
        kill -2 "$pid"
        rm "$pidf"
    else
        mkdir -p "$HOME/Videos/Screencasts"
        bf="$HOME/Videos/Screencasts/$(date +'%Y%m%dT%H%M%S')"
        vidf="$bf.$VIDEOEXT"
        logf="$bf.log"
        
        if [ "$1" == "fullscreen" ]; then
            wf-recorder $WF_RECORDER_OPTS -f "$vidf" > "$logf" 2>&1 &
        elif [ "$1" == "region" ]; then
            sleep 1
            wf-recorder $WF_RECORDER_OPTS -g "$(slurp)" -f "$vidf" > "$logf" 2>&1 &
        else
            echo "Argument $1 not valid"
            exit 1
        fi
        
        pid=$!
        printf "%d\n%s\n%s" "$pid" "$vidf" "$logf" > "$pidf"
    fi
}

case "$1" in
    status)
        status
        ;;
    toggle)
        if [ -z "$2" ]; then
            echo "Usage: $0 toggle [fullscreen|region]"
            exit 1
        fi
        toggle "$2"
        ;;
    *)
        echo "Usage: $0 {status|toggle}"
        exit 1
        ;;
esac
