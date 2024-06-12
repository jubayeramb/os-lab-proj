#!/bin/bash
JSON_FILE="commands.json"

# Function to get the current Linux distribution
get_distro() {
    if [ -f /etc/os-release ]; then
        # Extract the ID field from the os-release file
        . /etc/os-release
        echo "$ID"
    else
        echo "Error: Unable to determine Linux distribution."
        exit 1
    fi
}

main() {
    local action="$1"
    local app_name="$2"
    local distro="$3"
    local app_commands=$(jq -r --arg app "$app_name" --arg distro "$distro" --arg action "$action" '.[] | select(.name == $app) | .commands[$distro][$action][]' "$JSON_FILE")

    if [ -z "$app_commands" ]; then
        echo "Error: No $action commands found for $app_name on $distro"
        exit 1
    fi

    echo "${action^}ing $app_name on $distro..."
    eval "$app_commands"
}

# Get the distribution
distro=$(get_distro)

# Check that the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <install|uninstall> <app_name>"
    exit 1
fi

# Call the main function with the action, app name, and detected distribution
main "$1" "$2" "$distro"