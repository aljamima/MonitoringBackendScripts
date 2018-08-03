#!/bin/bash

lastRecord=$(mysql -ss -u root -p'Frostfiredragon1!!'  minersdb -N -e "SELECT id FROM miners ORDER BY id DESC LIMIT 1";)
firstRecord=$(mysql -ss -u root -p'Frostfiredragon1!!' minersdb -N -e "SELECT id FROM miners ORDER BY id ASC LIMIT 1";)
recordCount=$(mysql -ss -u root -p'Frostfiredragon1!!' minersdb -N -e "SELECT COUNT(*) from miners";)
echo "first=$firstRecord last=$lastRecord count=$recordCount"

function hashrates {
	if [ -z "$1" ]; then
		continue
	fi
	hashServer=$1
	hashStats=$(echo -n "stats+devs+summary+pools" | nc -w 1 $hashServer 4028 | tr -d '\0')
	HASHRATE=$(echo $hashStats | sed -e 's/,/\n/g' | grep -ia "GHS av" | cut -d "=" -f2 |tail -n 1)
	HASHRATE=${HASHRATE:0:6}
	MHASHRATE=$(echo $hashStats | sed -e 's/,/\n/g' | grep -ia "MHS av" | cut -d "=" -f2 |tail -n 1) 
	MHASHRATE=${MHASHRATE:0:6}
	if [ -z $HASHRATE ]; then
		echo "$MHASHRATE"
	else
		echo "$HASHRATE"
	fi
}

for id in $(seq $firstRecord $lastRecord); do 
	currentIp=$(mysql -ss -u root -p'Frostfiredragon1!!' -Dminersdb -e "SELECT minerIp FROM miners WHERE id='$id';")
	if [ -z "$currentIp" ]; then
		currentIp=$(./ipFromDhcp.sh $minerMac)
	fi
	currentHashrate=$(hashrates $currentIp)
#	if [ -z ${currentHashrate+x} ]; then
#		currentHashrate=$(./justHashrate.sh $currentIp)	
#	fi
	if [ -z $currentHashrate ]; then
		currentHashrate=$(./dragonHashrate.sh $currentIp)
	fi
	currentHashrate=${currentHashrate:0:6}
	updateHash="\"UPDATE miners SET hashrate='$currentHashrate' WHERE id='$id';\""
	eval $(echo mysql -u root -p'Frostfiredragon1!!' -Dminersdb -e "$updateHash")
done

