systemd service timer for mounting cloud storage with rclone

the scripts reads from a json configuration file located at `systemd/scripts/rclone-mounts.json` and launch rclone to mount the mountpoints

## CONFIGURATION FILE

syntax for the configuration file (do not put environment variables inside this file, **they will not be espanded**) 

```json
[
    { 
        "mount": "google drive", 
        "path": "/path/to/google-drive" 
    },
    { 
        "mount": "some rclone mount", 
        "path": "/some/other/path" 
    }
]
```

## SYSTEMD 

there is also a systemd timer to run this script at startup named `rclone-mount-all.timer`

## LOGS

the scripts logs the rclone's mount and path folder in `$SCRIPTS_HOME_FOLDER/rclone_mount_all.log`
 for debugging 