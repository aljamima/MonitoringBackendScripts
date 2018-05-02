#!/bin/bash
#### START SCRIPTING
#./grabIpZmap.sh
./grabIps.sh
sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 results.csv > ips.sorted
for server in $(cat ips.sorted); do
	APISTATS=`echo -n "stats" | nc -w 1 $1 4028`
	DESCR=`echo $APISTATS | sed -e 's/,/\n/g' | grep "Description" | cut -d "=" -f2`
	MAC=$(./macFromIp.sh $server)
	BM="bm"
	SG="sg"
	if [[ $DESCR = $BM* ]]; then
		echo "$server" >> /tmp/bmMinerIps.txt
		echo "$server $MAC" >> /tmp/bmMinerIpsMacs.txt
	elif [[ $DESCR = $SG* ]]; then 
		echo "$server" >> /tmp/sgMinerIps.txt
		echo "$server $MAC" >> /tmp/sgMinerIpsMacs.txt
	else
		echo "$checks is NOT a miner" >> /tmp/notMiner.txt
		echo "$server $MAC" >> /tmp/notMinerMacs.txt
	fi
done
#sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 fpingOutput > fping.sorted
#diff --changed-group-format="%>" --unchanged-group-format="" "zmap.sorted" "fping.sorted"
 		
	
