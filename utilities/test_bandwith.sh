#!/bin/bash
if [[ "$#" != '1' ]]; then echo 'wrong arguments use with HOSTNAME as parameter'; exit 1;fi
dd if=/dev/zero bs=4096 count=1048576 status=progress | ssh "$1"  'cat > /dev/null'
