#!/bin/bash
lastRecord=$(mysql -ss -u root -p'Frostfiredragon1!!'  minersdb -N -e "SELECT id FROM miners ORDER BY id DESC LIMIT 1";)
firstRecord=$(mysql -ss -u root -p'Frostfiredragon1!!' minersdb -N -e "SELECT id FROM miners ORDER BY id ASC LIMIT 1";)
recordCount=$(mysql -ss -u root -p'Frostfiredragon1!!' minersdb -N -e "SELECT COUNT(*) from miners";)

#function farmName {
        #hashServer=$1
        #hashStats=$(echo -n "stats+devs+summary+pools" | nc -w 1 $hashServer 4028 | tr -d '\0')
        #maxTemp=$(echo $hashStats | sed -e 's/,/\n/g' | grep "Temperature" | cut -d "=" -f2)
        #maxTemp=$(./tempsApi.sh $1 |tail -n 1)
        #if [ -z ${maxTemp+x} ]; then
        #        maxTemp=$(./tempsApiDragon.sh $1 |tail -n 1)
        #fi
        #echo "$maxTemp"
#}
#currentIp=$(mysql -ss -u root -p'Frostfiredragon1!!' -Dminersdb -e "SELECT minerIp FROM miners WHERE id='$id';")

#temps=$(./tempsApi.sh)
for id in $(seq $firstRecord $lastRecord); do 
	currentIp=$(mysql -ss -u root -p'Frostfiredragon1!!' -Dminersdb -e "SELECT minerIp FROM miners WHERE id='$id';")
	apistats=$(echo -n "pools+devs+summary+stats" | nc $currentIp 4028 2>/dev/null)
	worker=$(echo -n $apistats | sed -e 's/,/\n/g' | grep -a "User" | cut -d "=" -f2)

	#mac=$(mysql -ss -u root -p'Frostfiredragon1!!' -Dminersdb -e "SELECT macAddress FROM miners WHERE id='$id';")
	#currentTemp=$(temps $currentIp)
	#farmName=$(./getSiteName.sh)
	#temps=$(./tempsApi.sh $currentIp | tail -n 1)
	updateFarm="\"UPDATE miners SET poolUser='$worker' WHERE id='$id';\""
	eval $(echo mysql -u root -p'Frostfiredragon1!!' -Dminersdb -e "$updateFarm")
done
