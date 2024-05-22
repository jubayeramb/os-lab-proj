#!/bin/bash

# Define the path to the JSON file containing the install commands
JSON_FILE="commands.json"

# Function to install the specified app for the given distribution
install_app() {
    local app_name="$1"
    local distro="$2"
    local app_commands=$(jq -r --arg app "$app_name" --arg distro "$distro" '.[] | select(.name == $app) | .commands[$distro][]' "$JSON_FILE")

    if [ -z "$app_commands" ]; then
        echo "Error: No install commands found for $app_name on $distro"
        exit 1
    fi

    echo "Installing $app_name on $distro..."
    eval "$app_commands"
}

# Main function
main() {
    if [ $# -ne 3 ]; then
        echo "Usage: $0 install <app_name> <distro>"
        exit 1
    fi

    local action="$1"
    local app_name="$2"
    local distro="$3"

    if [ "$action" != "install" ]; then
        echo "Error: Unknown action $action"
        exit 1
    fi

    install_app "$app_name" "$distro"
}

main "$@"
