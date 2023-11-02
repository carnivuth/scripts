#!/bin/bash
#mount remote storage with rclone 
source "$HOME/scripts/settings.sh"

cat "$SCRIPTS_HOME_FOLDER/systemd/scripts/rclone-mounts.json" | jq -rc '.[]' | while read mountpoint; do
    
    mount="$(echo $mountpoint | jq -r '.mount')"
    path="$(echo $mountpoint | jq -r '.path')"
    echo "$mount"  >> "$SCRIPTS_LOGS_FOLDER/rclone_mount_all.log" 
    echo "$path"  >> "$SCRIPTS_LOGS_FOLDER/rclone_mount_all.log" 
    rclone mount "$mount": "$path"   >> "$SCRIPTS_LOGS_FOLDER/rclone_mount_all.log" 
done 
