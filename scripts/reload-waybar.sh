CONFIG_FILES="$HOME/.config/waybar/config-top $HOME/.config/waybar/style-top.css $HOME/.config/waybar/config-bottom $HOME/.config/waybar/style-bottom.css"

trap "pkill waybar" EXIT

while true; do
  waybar -c ~/.config/waybar/config-top -s ~/.config/waybar/style-top.css &
  waybar -c ~/.config/waybar/config-bottom -s ~/.config/waybar/style-bottom.css &
  inotifywait -e create,modify $CONFIG_FILES
  pkill waybar
done
