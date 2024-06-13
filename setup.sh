#!/bin/bash

# Define the script name and installation paths
SCRIPT_NAME="upm"
SCRIPT_INSTALL_PATH="/usr/local/bin"
SHARE_PATH="/usr/local/share/$SCRIPT_NAME"

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

# Check if the user has sudo privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Please use sudo."
   exit 1
fi

# Create the directory for shared files if it doesn't exist
mkdir -p "$SHARE_PATH"

# Copy the script and other files to the installation directories
cp "upm.sh" "$SCRIPT_INSTALL_PATH/$SCRIPT_NAME"
cp -a "." "$SHARE_PATH"

# Make the script executable
chmod +x "$SCRIPT_INSTALL_PATH/$SCRIPT_NAME"
chmod -R a+rX "$SHARE_PATH"

# Check if the "jq" command is installed, if not, istall it
if ! command -v jq &> /dev/null; then
    distro=$(get_distro)
    case $distro in
        "ubuntu" | "debian" | "pop" | "kali")
            sudo apt update
            sudo apt install -y jq
            ;;
        "fedora" | "centos" | "rhel")
            sudo dnf install -y jq
            ;;
        "arch" | "manjaro")
            sudo pacman -Sy jq
            ;;
        *)
            echo "Error: Unsupported distribution."
            exit 1
            ;;
    esac
    echo ""
fi


# Verify the installation
if [[ -f "$SCRIPT_INSTALL_PATH/$SCRIPT_NAME" && -f "$SHARE_PATH/help.txt" && -f "$SHARE_PATH/commands.json" ]]; then
  echo "$SCRIPT_NAME has been installed successfully to $SCRIPT_INSTALL_PATH."
  echo "Modules has been installed to $SHARE_PATH."
  echo "You can now run '$SCRIPT_NAME --help' to see the help message."
else
  echo "There was an issue installing $SCRIPT_NAME. Please check the script and try again."
fi
