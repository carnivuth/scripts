rofi applet for open projects folders with different programs that support the `program-name /path/to/project` like `code`

the scripts show a list of folders and open one of them with the `$1` parameter as the IDE, for example:

```bash
./scripts/carnivuth-DE/rofi/launchprojects/launchprojects.sh code
```

will open the selected project with visual studio code

## CONFIGURATION

the applets read from an [ARRAY_DATA_FILE](ARRAY_DATA_FILE.md) the parent folders where look for project 