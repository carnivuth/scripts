# Music player

The repository contains a series of scripts that interacts together to play music from a [subsonic](https://www.subsonic.org/pages/api.jsp) compatible server the scripts interacts together as follows

```mermaid
flowchart LR
A@{shape: proc, label: L.sh}
B@{shape: proc, label: mpv}
C@{shape: doc, label: mpv socket}
D@{shape: proc, label: player.sh}
E@{shape: doc, label: subsonic_client.sh }
F@{shape: cloud, label: subsonic server }
G@{shape: doc, label: control_mpv.sh }
A -- starts --> B -- listen to --> C
D & A -- uses --> G -- that send json commands through --> C
A --> E --> F
```

> [!NOTE]
> Why this? Cause it's fun obviously 😜

`mpv` is treated as a daemon process started from [L.sh](./menu_engine.md) script, using the `album` `artist` and `playlist` types, and subsequent scripts that dialog with `mpv` use the socket channel to communicate, this scripts are also bind to some hyprland keybindings

## Authentication

Authentication through the subsonic server is done with username and password that need to be configured in the [configuration file](./configuration.md) using the following variables

```bash
SUBSONIC_API_ENDPOINT=""
SUBSONIC_USERNAME=""
SUBSONIC_PASSWORD=""
```
