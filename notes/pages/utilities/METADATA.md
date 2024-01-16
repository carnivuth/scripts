# METADATA

Script for editing metadata of audio file using [awk](http://www.awklang.org/) and [ffmpeg](https://ffmpeg.org/).

The script read from a file given as parameter the awk program to run in order to extract from the filename of the track the metadata value,  metadata supported are:

- title
- album
- artist

you must also pass the source folder where tracks are located, they must have the same file format and you need to specify it with the `-f` option

## PARAMETERS

- `-t`:   awk program file to get title from filename, format -t ''awk program''
- `-a`:   awk program file to get artist from filename -a ''awk program''
- `-l`:   awk program file to get album from filename -l ''awk program''
- `-f`:   format of audio files

## CALL EXAMPLES

```bash 
metadata.sh $HOME/Music $HOME/Music-with-metadata -t 'some-awk-program.awk' -f 'mp3'
```

`some-awk-program.awk` content:

```awk
BEGIN{FS="-"}{gsub(/^[ \t]+|[ \t]+$/, "");print $2}
```

this will get the title of the track from a file named artist-title.format