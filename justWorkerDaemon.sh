#!/bin/sh
checks=$1
apistats=$(echo -n "pools+devs+summary+stats" | nc $checks 4028 2>/dev/null)
worker=$(echo -n $apistats | sed -e 's/,/\n/g' | grep -a "User" | cut -d "=" -f2)
echo "$worker" | tee -a finList.txt
