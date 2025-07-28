# Nextcloud systemd sync daemon (nxtcdd)

Systemd managed daemon to sync [nextcloud](https://nextcloud.com/) folders

This script tries to replace the desktop client using the `nextcloudcmd` to run sync operations and `inotifywait` to listen to file changes in the monitored folders.

## Usage

The script is meant to be run using [systemd template units](https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html), each spawned unit manage a specific nextcloud folder under your home directory, so if your nextcloud folders are as follows:

> [!TIP]
> For more information on how this daemon is implemented watch [this](systemd_templates.md)

```text
/
├── Camera
├── Documents
├── projects
└── wallpapers
```

To sync only the `projects` and the `Documents` folders run

```bash
systemctl --user start nxtcdd@Documents
systemctl --user start nxtcdd@projects
```

> [!TIP]
> To enable systemd units for specific folders modify the variable `TEMPLATE_SERVICES` in the [config file](configuration.md)

## Credentials

To enable the script credentials must be provided in the [configuration file](configuration.md)

```bash
NEXTCLOUD_URL="url to the nextcloud instance"
NXTCDD_USERNAME="username"
NXTCDD_PASSWORD="password"
```

## Troubleshooting

The script runs a sync operation each time a file is modified inside the watched folder, when there are errors in the sync operation watch the daemon journal with

```bash
journalctl --user -fu ntxcdd@[FOLDER]
```
