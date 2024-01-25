#prompt
prompt_connections='Connections'

# print menu to ask for password
ask_password() {
    menu_cmd ${prompt_pwd}
}

# print connection list
print_connections() {
    echo -e "$(nmcli -f name connection | grep -v NAME)" | menu_cmd ${prompt_connections}
}

delete_connection() {
    conneciton=$(print_connections | xargs)

    # check if item is a valid connection
    if [ "$(nmcli -f name connection | grep "$conneciton")" != "" ]; then

        nmcli connection delete "$conneciton" && notify normal "deleted" "$conneciton succesfully deleted"
    fi
}
