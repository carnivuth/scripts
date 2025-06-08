---
date: '2025-06-07T16:37:43+02:00'
draft: true
title: 'Nxtcdd'
series: ["Documentation"]
series_order: 6
---

## Development documentation

>[!WARNING]
> this documentation is for development only

### Systemd templates scripts

Some tools need to run as daemons and monitor folders such as [the script for nextcloud synchronization](bin/nxtcdd.sh) and the [folder manager](bin/folder_manager.sh), this scripts are implemented using systemd template units functionality to spawn multiple instances of the daemon and manages different directories:

```mermaid
flowchart LR
A[(nextcloud folders:<br>Documents<br>Pictures)]
B[nxtcdd.service]
C[nxtcdd-Documents]
D[nxtcdd.sh start -d Documents]
E[nxtcdd-Pictures]
F[nxtcdd.sh start -d Pictures]
A --> B -- spawns --> C & E
C -- runs --> D
E -- runs --> F
```
