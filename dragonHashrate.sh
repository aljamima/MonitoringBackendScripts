#!/bin/bash 
server=$1
#    hashStats=$(echo -n "stats" | nc -w 1 $server 4028 2>/dev/null)
#    lessStats=$(echo -n "summary" | nc -w 1 $server 4028 2>/dev/null)
apistats=$(echo -n "summary+devs+pools+stats" | nc -w 1 $server 4028 2>/dev/null)
#    poolStats=`echo -n "pools" | nc $server 4028 2>/dev/null`
#    MHASHRATE=`echo $apistats | sed -e 's/,/\n/g' | grep "MHS av" | cut -d "=" -f2`    
#    GHASHRATE=`echo $hashStats | sed -e 's/,/\n/g' | grep "GHS av" | cut -d "=" -f2`
#    THASHRATE=`echo $apistats | sed -e 's/,/\n/g' | grep "THS av" | cut -d "=" -f2`
DRAGONHASH=$(echo -n $apistats | sed -e 's/,/\n/g' | grep -a "MHS av" | cut -d "=" -f2 | head -n 1)
DRAGONHASHRATE=$(echo $DRAGONHASH | head -n 1)
#    POOLS=`echo $apistats | sed -e 's/,/\n/g' | grep "URL" | cut -d "=" -f2`c
#    TYPE=`echo $lessStats | sed -e 's/,/\n/g' | grep "Description" | cut -d "=" -f2`
#    echo  "$server with $DRAGONHASH GH/s " | tee -a hashratesL3.txt
echo "$DRAGONHASH"
exit 0
