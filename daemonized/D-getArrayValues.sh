#!/bin/bash
#array=$(<ipList.txt)
IFS=$'\n' read -d '' -r -a array < ipList.txt
for x in "$@"
do
    echo "${array[x]}"
done
