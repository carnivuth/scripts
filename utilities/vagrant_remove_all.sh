#!/bin/bash

MACHINES="$(vagrant global-status --machine-readable | grep machine-id | awk -F , '{print $4}')"

echo "$MACHINES" | while read machine ; do
  vagrant destroy -f $machine 
done
