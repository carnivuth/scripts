# send notification
notify(){
    notify-send -a "Network-menu" -u "$1" "$2" "$3"
}