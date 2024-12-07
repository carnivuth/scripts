#!/bin/bash
if [[ $# -lt 3 ]]; then echo "pass at least an outfile and 2 files to merge"; exit 1; fi
if [[ -f $1 ]]; then echo "outfile $1 already exists"; exit 1; fi
OUTFILE="$1"
shift
gs \
  -dBATCH\
  -dNOPAUSE\
  -q\
  -sDEVICE=pdfwrite\
  -dNumRenderingThreads=$(nproc)\
  -dCompatibilityLevel=1.3\
  -dPDFSETTINGS=/prepress\
  -sOutputFile="$OUTFILE" "$@"

