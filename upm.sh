#!/bin/bash

# detect the distribution name
detect_distribution() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$(echo "$NAME" | sed -e 's/[^[:alnum:]]\+//g' -e 's/\b\(.\)/\u\1/g')"
    elif command -v lsb_release &> /dev/null; then
        echo "$(lsb_release -si | sed -e 's/[^[:alnum:]]\+//g' -e 's/\b\(.\)/\u\1/g')"
    elif [ -f /etc/debian_version ]; then
        echo "Debian"
    elif [ -f /etc/redhat-release ]; then
        echo "RedHat"
    elif [ -f /etc/arch-release ]; then
        echo "ArchLinux"
    else
        echo "-1"
    fi
}

distribution=$(detect_distribution)

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
    if [ $# -ne 2 ]; then
        echo "Usage: $0 install <app_name>"
        exit 1
    fi

    local action="$1"
    local app_name="$2"
    local distro="$distribution"

    if [ "$action" != "install" ]; then
        echo "Error: Unknown action $action"
        exit 1
    fi

    # if the distribution is not detected, ask the user to provide it
    if [ "$distro" == "-1" ]; then
        echo "Error: Could not detect the distribution. Please provide the distribution name."
        read -p "Distribution: " distro
    fi

    # check if the jq command is installed; if not, install it
    if ! command -v jq &> /dev/null; then
        echo "jq is not installed. Installing..."
        case "$distro" in
            Debian|Ubuntu)
                sudo apt update
                sudo apt install -y jq
                ;;
            Fedora|Red\ Hat|CentOS)
                sudo yum install -y jq
                ;;
            Arch\ Linux)
                sudo pacman -Sy jq
                ;;
            *)
                echo "Error: Unsupported distribution $distro"
                exit 1
                ;;
        esac
    fi

    install_app "$app_name" "$distro"
}

main "$@"
