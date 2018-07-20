#!/bin/bash

lastRecord=$(mysql -ss -u root -p'Frostfiredragon1!!'  minersdb -N -e "SELECT id FROM miners ORDER BY id DESC LIMIT 1";)
firstRecord=$(mysql -ss -u root -p'Frostfiredragon1!!' minersdb -N -e "SELECT id FROM miners ORDER BY id ASC LIMIT 1";)
recordCount=$(mysql -ss -u root -p'Frostfiredragon1!!' minersdb -N -e "SELECT COUNT(*) from miners";)

echo "first=$firstRecord last=$lastRecord count=$recordCount"

for id in $(seq $firstRecord $lastRecord); do 
	currentIp=$(mysql -ss -u root -p'Frostfiredragon1!!' -Dminersdb -e "SELECT minerIp FROM miners WHERE id='$id';")
	#mac=$(mysql -ss -u root -p'Frostfiredragon1!!' -Dminersdb -e "SELECT macAddress FROM miners WHERE id='$id';")
	#currentTemp=$(temps $currentIp)
	currentHashrate=$(hashrates $currentIp)
	if [ -z $currentHashrate ]; then
		currentHashrate=$(./dragonHashrate.sh $currentIp)
	fi
	currentHashrate=${currentHashrate:0:6}
	#connector="mysql -u root -p'Frostfiredragon1!!' -Dminersdb -e "
	updateHash="\"UPDATE miners SET hashrate='$currentHashrate' WHERE id='$id';\""
	#hashConcat="$connector $updateHash"
	eval $(echo mysql -u root -p'Frostfiredragon1!!' -Dminersdb -e "$updateHash")
done

