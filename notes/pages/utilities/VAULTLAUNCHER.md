script for obsidian's vault fastopening trough obsidian uri

the scripts prints a rofi menu with the content of `folder.sh` file and use `xdg-open`  to open obsidian on the selected vault 

there is a [config file](ARRAY_DATA_FILE.md) `folder.sh` under `carnivuth-DE/rofi/vaultlauncher` with absolute paths to obsidian vaults to fastopen

```bash
#!/bin/bash

ARRAY=("$HOME/some/obsidian/vault" "/other/vault")
```