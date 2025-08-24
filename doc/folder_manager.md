# Folder manager

Utility to manage content inside directories, this script is intended to run as a systemd units watching a specific directory

The script will trigger itself when a file is closed after been open in write mode (`close_write` event) and re arrange the files inside the monitored directory

## Usage

To use the script just enable the systemd template services for the directories that need to be monitored, for example to monitor the `~/Downloads` and `~/Pictures` directory run:

```bash
systemctl --user --enable --now folder_manager@{Downloads,Pictures}
```

This will spawn 2 systemd template units one for each directory.
