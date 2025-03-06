CONFIG_FILES="$HOME/.config/waybar/config $HOME/.config/waybar/style.css"

trap "pkill waybar" EXIT

while true; do
    waybar &
    inotifywait -e create,modify $CONFIG_FILES
    pkill waybar
done
