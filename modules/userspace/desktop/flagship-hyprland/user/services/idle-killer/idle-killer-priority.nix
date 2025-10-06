{ pkgs, createCommand, ... }:

createCommand {
  name = "idle-killer-priority";
  prefix = "";
  buildInputs = with pkgs; [ hyprland jq ];
  command = ''
    IFS=$'\n\t'

    SCRIPT_NAME="$(basename "$0")"
    CONFIG_PATH="''${XDG_CONFIG_HOME:-$HOME/.config}/idle-killer/config"
    if [[ -f "$CONFIG_PATH" ]]; then
      # shellcheck source=/dev/null
      source "$CONFIG_PATH"
    else
      echo "Config not found at $CONFIG_PATH" >&2
      exit 1
    fi

    JQ="$(command -v jq || true)"
    HYPRCTL="$(command -v hyprctl || true)"
    if [[ -z "$HYPRCTL" ]]; then
      echo "hyprctl not found in PATH — must run inside Hyprland." >&2
      exit 2
    fi

    log() { logger -t "$LOGTAG" -- "$SCRIPT_NAME: $*"; }

    # queue: newest at index 0; oldest at last index
    QUEUE=()

    # managed apps list
    function get_managed_list() {
      local arr=()
      if [[ -z "''${MANAGED_APPS// }" ]]; then
        for k in "''${!APP_TIMEOUTS[@]}"; do
          arr+=("$k")
        done
      else
        read -ra arr <<<"$MANAGED_APPS"
      fi
      echo "''${arr[@]}"
    }
    MANAGED=( $(get_managed_list) )
    # if [[ ''${#MANAGED[@]} -eq 0 ]]; then
    #   log "No managed apps found; exiting."
    #   exit 0
    # fi

    # helpers similar to concurrent script
    get_timeout_for() {
      local app="$1"
      if [[ -n "''${APP_TIMEOUTS[$app]:-}" ]]; then
        echo "''${APP_TIMEOUTS[$app]}"
      else
        echo "$DEFAULT_TIMEOUT"
      fi
    }
    get_focused_class_and_pid() {
      if [[ -n "$JQ" ]]; then
        local j; j="$($HYPRCTL activewindow -j 2>/dev/null || true)"
        if [[ -n "$j" ]]; then
          local cls pid
          cls="$(printf '%s' "$j" | $JQ -r '.class // empty')"
          pid="$(printf '%s' "$j" | $JQ -r '.pid // empty')"
          echo "''${cls}|''${pid}"
          return
        fi
      fi
      local out; out="$($HYPRCTL activewindow 2>/dev/null || true)"
      local cls pid
      cls="$(printf '%s' "$out" | awk -F'class: ' '/class:/ {print $2; exit}' | awk '{$1=$1;print}')"
      pid="$(printf '%s' "$out" | awk '/pid:/ {print $2; exit}')"
      echo "''${cls}|''${pid}"
    }
    get_pids_for_class() {
      local app="$1"
      if [[ -n "$JQ" ]]; then
        $HYPRCTL clients -j 2>/dev/null | $JQ -r --arg a "$app" '.[] | select(.class == $a) | .pid' 2>/dev/null || true
        return
      fi
      $HYPRCTL clients 2>/dev/null | awk -v RS= -v app="$app" '
        /class:/{ if ($0 ~ ("class: " app)) {
          for(i=1;i<=NF;i++) if($i=="pid:") {print $(i+1); break}
        }}' || true
    }
    has_unfinished_work() {
      local app="$1"
      local hook="''${UNFINISHED_HOOK_PREFIX}''${app}"
      if [[ -x "$hook" ]]; then
        "$hook"
        return $?
      fi
      return 1
    }
    kill_pids() {
      local app="$1"; shift
      local pids=("$@")
      if [[ ''${#pids[@]} -eq 0 ]]; then
        if [[ "$KILL_METHOD" == "pkill" ]]; then
          log "Attempting pkill for $app"
          pkill -f "$app" || true
        fi
        return
      fi
      log "Sending TERM to ''${pids[*]} for app=$app"
      kill "''${pids[@]}" 2>/dev/null || true
      sleep "$KILL_GRACE"
      local alive=()
      for p in "''${pids[@]}"; do
        if kill -0 "$p" 2>/dev/null; then
          alive+=("$p")
        fi
      done
      if [[ ''${#alive[@]} -gt 0 ]]; then
        log "Sending KILL to ''${alive[*]} for app=$app"
        kill -9 "''${alive[@]}" 2>/dev/null || true
      fi
    }

    # queue operations
    remove_from_queue() {
      local app="$1"
      local new=()
      for x in "''${QUEUE[@]}"; do
        [[ "$x" != "$app" ]] && new+=("$x")
      done
      QUEUE=("''${new[@]}")
    }
    push_front() {
      local app="$1"
      remove_from_queue "$app"
      QUEUE=("$app" "''${QUEUE[@]}")
    }
    push_if_running_and_missing() {
      local app="$1"
      # if running and not already in queue, push front
      local pids=( $(get_pids_for_class "$app") )
      if [[ ''${#pids[@]} -gt 0 ]]; then
        for x in "''${QUEUE[@]}"; do [[ "$x" == "$app" ]] && return; done
        QUEUE=("$app" "''${QUEUE[@]}")
      fi
    }

    # timer for oldest app
    oldest_timer=0
    current_oldest=""

    trap 'log "Terminating"; exit 0' SIGINT SIGTERM

    # log "Starting priority idle-killer for: ''${MANAGED[*]} (poll=''${POLL_INTERVAL}s)"

    while true; do
      IFS='|' read -r focused_class focused_pid <<< "$(get_focused_class_and_pid)"

      # Update queue membership: ensure running managed apps are in queue
      for app in "''${MANAGED[@]}"; do
        push_if_running_and_missing "$app"
      done

      # remove stopped apps from queue
      newq=()
      for app in "''${QUEUE[@]}"; do
        if [[ -n "$(get_pids_for_class "$app")" ]]; then
          newq+=("$app")
        fi
      done
      QUEUE=("''${newq[@]}")

      # If focused change => move focused to front
      if [[ -n "$focused_class" ]]; then
        push_front "$focused_class"
        # for want in "''${MANAGED[@]}"; do
        #   if [[ "$focused_class" == "$want" ]]; then
        #     push_front "$focused_class"
        #     break
        #   fi
        # done
      fi

      # Determine oldest (last element)
      if [[ ''${#QUEUE[@]} -eq 0 ]]; then
        current_oldest=""
        oldest_timer=0
        sleep "$POLL_INTERVAL"
        continue
      fi
      new_oldest="''${QUEUE[-1]}"

      # if oldest changed -> switch timer
      if [[ "$new_oldest" != "$current_oldest" ]]; then
        current_oldest="$new_oldest"
        oldest_timer="$(get_timeout_for "$current_oldest")"
        log "Switched oldest to '$current_oldest' (timer=''${oldest_timer}s)"
      fi

      # If oldest is focused -> reset timer
      if [[ -n "$focused_class" && "$focused_class" == "$current_oldest" ]]; then
        oldest_timer="$(get_timeout_for "$current_oldest")"
        sleep "$POLL_INTERVAL"
        continue
      fi

      # If unfinished work -> skip decrement
      if has_unfinished_work "$current_oldest"; then
        sleep "$POLL_INTERVAL"
        continue
      fi

      # decrement
      oldest_timer=$(( oldest_timer - POLL_INTERVAL ))

      if (( oldest_timer <= 0 )); then
        pids=( $(get_pids_for_class "$current_oldest") )
        if [[ ''${#pids[@]} -gt 0 ]]; then
          log "Oldest timer expired for $current_oldest; killing PIDs: ''${pids[*]}"
          kill_pids "$current_oldest" "''${pids[@]}"
        else
          log "Oldest $current_oldest had no pids when timer expired; removing"
        fi
        # remove from queue & reset current_oldest
        remove_from_queue "$current_oldest"
        current_oldest=""
        oldest_timer=0
      fi

      sleep "$POLL_INTERVAL"
    done
  '';
}
