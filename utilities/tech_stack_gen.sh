#!/bin/bash
TECH_STACK='ansible terraform linux java javascript bash vagrant docker go python' 
output=''
for tech in ${TECH_STACK} ;do
  output="$output![](https://raw.githubusercontent.com/devicons/devicon/master/icons/$tech/$tech-original.svg)"
done
echo "$output"
