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
function temps {
        hashServer=$1
        hashStats=$(echo -n "stats+devs+summary+pools" | nc -w 1 $hashServer 4028 | tr -d '\0')
        maxTemp=$(echo $hashStats | sed -e 's/,/\n/g' | grep "Temperature" | cut -d "=" -f2)
        #maxTemp=$(./tempsApi.sh $1)
	if [ -z ${maxTemp+x} ]; then
                maxTemp=$(./tempsApiDragon.sh $1 |tail -n 1)
        fi
        echo "$maxTemp"
}

for id in $(seq $firstRecord $lastRecord); do 
	currentIp=$(mysql -ss -u root -p'Frostfiredragon1!!' -Dminersdb -e "SELECT minerIp FROM miners WHERE id='$id';")
	mac=$(mysql -ss -u root -p'Frostfiredragon1!!' -Dminersdb -e "SELECT macAddress FROM miners WHERE id='$id';")
	currentTemp=$(temps $currentIp)
	currentHashrate=$(hashrates $currentIp)
#	if [ -z ${currentHashrate+x} ]; then
#		currentHashrate=$(./justHashrate.sh $currentIp)	
#	fi
	if [ -z $currentHashrate ]; then
		currentHashrate=$(./dragonHashrate.sh $currentIp)
	fi
	currentHashrate=${currentHashrate:0:6}
	connector="mysql -u root -p'Frostfiredragon1!!' -Dminersdb -e "
	updateHash="\"UPDATE miners SET hashrate='$currentHashrate' WHERE id='$id';\""
	hashConcat="$connector $updateHash"
	eval $(echo mysql -u root -p'Frostfiredragon1!!' -Dminersdb -e "$updateHash")
	#echo "$connector $updateHash"
	updateMaxTemp="\"UPDATE miners SET maxTemp='$currentTemp' WHERE id='$id';\""
	tempConcat="$connector $updateMaxTemp"
	eval $(echo mysql -u root -p'Frostfiredragon1!!' -Dminersdb -e "$updateMaxTemp")
	workerName=$(./getWorkerNames.sh $currentIp)
	updateWorker="\"UPDATE miners SET poolUser='$workerName' WHERE id='$id';\""
	eval $(echo mysql -u root -p'Frostfiredragon1!!' -Dminersdb -e "$updateWorker")


	#echo "$connector$updateMaxTemp" |tee -a >> logger
	#updateUptime="mysql -u root -p'Frostfiredragon1!!' -h zoomhash.us -Dminersdb -e "UPDATE miners SET uptime = '$currentUptime' WHERE id='$id';""
	#echo "$updateUptime" |tee -a >> logger
	#updateIp=" UPDATE miners SET minerIp = '$currentIp' WHERE id='$id';"
	#echo "$connector $updateIp" |tee -a >> logger
done



#############CURL SHOULD CALL CUSTOM 'edit2.php' SCRIPT######################################eventually
#start="curl 'http://localhost/edit.php' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Origin: http://localhost' -H 'Upgrade-Insecure-Requests: 1' -H 'Content-Type: application/x-www-form-urlencoded' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Referer: http://localhost/edit.php?id=2' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9,es-419;q=0.8,es;q=0.7,ru;q=0.6'"
#end="--data 'minerIp=10.2.3.4&macAddress=aa%3Abb%3Acc%3Aaa%3Abb%3Acc&minerType=Antminer&plocation=1-1-1-2&hashrate=11.27&maxTemp=70&farmName=Quincy-Division&numCards=3&uptime=120&poolUser=BTC.Zoomhash&comments=empty&id=2&update=Update' --compressed"
#concat="$start $end"
#echo $concat


