#!/bin/bash
id="$( keyctl search @s user ssh_pwd)"
if [[ "$id" == '' || "$id" == *'not available'* ]]; then
    echo insert ssh pwd
    read -s ssh_pwd
    id="$(echo -n $ssh_pwd | keyctl padd user ssh_pwd @s)"
    echo 'ssh pwd saved'
fi
echo "ssh to $1"
sshpass -p "$(keyctl print $id )" ssh "$1"
