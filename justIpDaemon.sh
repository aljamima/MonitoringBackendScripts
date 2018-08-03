#!/bin/bash

# this works.. its def a formatting issue:
#mysql -u root '-pFrostfiredragon1!!' -Dminersdb -e "UPDATE miners SET maxTemp='76' WHERE id=4457;"


lastRecord=$(mysql -ss -u root -p'Frostfiredragon1!!'  minersdb -N -e "SELECT id FROM miners ORDER BY id DESC LIMIT 1";)
firstRecord=$(mysql -ss -u root -p'Frostfiredragon1!!' minersdb -N -e "SELECT id FROM miners ORDER BY id ASC LIMIT 1";)
recordCount=$(mysql -ss -u root -p'Frostfiredragon1!!' minersdb -N -e "SELECT COUNT(*) from miners";)
echo "first=$firstRecord last=$lastRecord count=$recordCount"

function hashrates {
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
	#currentIp=$(mysql -ss -u root -p'Frostfiredragon1!!' -Dminersdb -e "SELECT minerIp FROM miners WHERE id='$id';")
	mac=$(mysql -ss -u root -p'Frostfiredragon1!!' -Dminersdb -e "SELECT macAddress FROM miners WHERE id='$id';")
	currentIp=$(./ipFromDhcp.sh $mac)
	#currentTemp=$(temps $currentIp)
	#currentHashrate=$(hashrates $currentIp)
#	if [ -z ${currentHashrate+x} ]; then
#		currentHashrate=$(./justHashrate.sh $currentIp)	
#	fi
	#if [ -z $currentHashrate ]; then
	#	currentHashrate=$(./dragonHashrate.sh $currentIp)
	#fi
	#currentHashrate=${currentHashrate:0:6}
	connector="mysql -u root -p'Frostfiredragon1!!' -Dminersdb -e "
	#updateHash="\"UPDATE miners SET hashrate='$currentHashrate' WHERE id='$id';\""
	#eval $(echo mysql -u root -p'Frostfiredragon1!!' -Dminersdb -e "$updateHash")
	#echo "$connector $updateHash"
	#updateMaxTemp="\"UPDATE miners SET maxTemp='$currentTemp' WHERE id='$id';\""
	#tempConcat="$connector $updateMaxTemp"
	#eval $(echo mysql -u root -p'Frostfiredragon1!!' -Dminersdb -e "$updateMaxTemp")
	#workerName=$(./getWorkerNames.sh $currentIp)
	#updateWorker="\"UPDATE miners SET poolUser='$workerName' WHERE id='$id';\""
	#eval $(echo mysql -u root -p'Frostfiredragon1!!' -Dminersdb -e "$updateWorker")
	#echo "$connector$updateMaxTemp" |tee -a >> logger
	#updateUptime="mysql -u root -p'Frostfiredragon1!!' -h zoomhash.us -Dminersdb -e "UPDATE miners SET uptime = '$currentUptime' WHERE id='$id';""
	#echo "$updateUptime" |tee -a >> logger
	updateIp="\"UPDATE miners SET minerIp='$currentIp' WHERE id='$id';\""
	eval $(echo "$connector $updateIp")
done


