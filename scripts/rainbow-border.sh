# Define the rainbow colors
colors=(
    "rgba(ff0000ff)"  # Red
    "rgba(ff7f00ff)"  # Orange
    "rgba(ffff00ff)"  # Yellow
    "rgba(00ff00ff)"  # Green
    "rgba(00ffffff)"  # Cyan
    "rgba(0000ffff)"  # Blue
    "rgba(8b00ffff)"  # Purple
)

# Number of colors in the array
num_colors=${#colors[@]}

# Function to shift the colors
shift_colors() {
    local first_color=$1
    local rest_colors=("${@:2}")
    echo "${rest_colors[@]}" "$first_color"
}

# Infinite loop to animate the gradient
while true; do
    # Shift the colors array
    colors=($(shift_colors "${colors[@]}"))

    # Construct the gradient string
    gradient=$(IFS=" " ; echo "${colors[*]} 45deg")

    echo $gradient

    # Update the active border color in Hyprland
    hyprctl keyword general:col.active_border "$gradient" > /dev/null

    # Adjust the sleep duration to control the speed of the animation
    sleep 0.25
done
