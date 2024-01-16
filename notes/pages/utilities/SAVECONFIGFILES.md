utility for program configurations backup

## HOW IT WORKS

the script copy all file defined in the [datafiles](#DATAFILES) and creates a tar archive with all config file defined

the scripts copy all files under the `$SCRIPTS_VAR_FOLDER` and compress them in `$SCRIPTS_LOCAL_FOLDER`
## DATAFILES
 
 there are some configuration file located under `utilities/backup-files`  to define which config file will be saved, files are:

- `configfiles` for files under `.config` folder (files written in this file will be saved under `$SCRIPTS_RUN_FOLDER/config.backup.config.$timestamp` )

- `systemfiles` for files under `$HOME` folder (files written in this file will be saved under `$SCRIPTS_RUN_FOLDER/config.backup.home.$timestamp` )

- `homefiles` for files under `/etc` folder (files written in this file will be saved under `$SCRIPTS_RUN_FOLDER/config.backup.system.$timestamp` )

### DATAFILE FORMAT

do not use env variables (es. `$HOME`) **they will not be espanded**

```BASH
/some/path 
/some/other/path 
```

