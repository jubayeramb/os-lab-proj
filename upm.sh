SCRIPT_NAME=upm
SHARE_PATH="/usr/local/share/$SCRIPT_NAME"

main() { 
    local action="$1"
    local app_name="$2"

    if [ "$action" == "install" ] || [ "$action" == "uninstall" ]; then
        source "$SHARE_PATH/manage.sh" $action $app_name
        exit 1
    elif [ "$action" == "--help" ]; then
        cat "$SHARE_PATH/help.txt"
        exit 1
    elif [ "$action" == "list" ]; then
        source "$SHARE_PATH/list.sh"
        exit 1
    else
        echo "Usage: $SCRIPT_NAME --help"
        exit 1
    fi
}

main "$@"