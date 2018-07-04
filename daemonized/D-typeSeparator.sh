#!/bin/bash
sudo -v
#### START SCRIPTING | tr -d '\0'
####            var=$(cat somefile) is more efficiently written var=$(<somefile)

##
##    WE CAN SEPERATE BY SOFTWARE MINER IS RUNNING... 'bmMiner' for S9, 'gmMiner' for Genesis GPU, 'cgMiner' for the L3
##
rm -f results.csv 2>/dev/null
touch results.csv
rm -f ips.sorted 2>/dev/null
touch ips.sorted
rm -f /tmp/bmMinerIpsMacs.txt 2>/dev/null
touch /tmp/bmMinerIpsMacs.txt
rm -f /tmp/sgMinerIpsMacs.txt 2>/dev/null
touch /tmp/sgMinerIpsMacs.txt
rm -f /tmp/cgMinerIpsMacs.txt 2>/dev/null
touch /tmp/cgMinerIpsMacs.txt
rm -f /tmp/notMinerMacs.txt 2>/dev/null
touch /tmp/notMinerMacs.txt
if [ -z ${1+x} ]; then
        echo "Starting To Scan 10.2.1.1/22 Range"
	sudo fping -a -g 10.2.1.1/22 2>/dev/null > results.csv
else
        echo "Starting To Scan $1 Range"
	sudo fping -a -g $1 2>/dev/null > results.csv
fi
echo "Finished Scan, Checking Miner Types"
sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 results.csv > ips.sorted
for server in $(<ips.sorted); do
	APISTATS=$(echo -n "stats" | nc -w 1 $server 4028 2>/dev/null | tr -d '\0')
	DESCR=$(echo $APISTATS | sed -e 's/,/\n/g' | grep "Description" | cut -d "=" -f2)
	MAC=$(timeout 1 ./macFromIp.sh $server)
	BM="bm"
	SG="sg"
	CG="cg"
	if [ -z ${MAC+x} ]; then
		echo "$server Is Causing Problems" | tee -a /tmp/notMinerMacs.txt
		continue
	fi
	if [[ $DESCR = $BM* ]]; then
#		echo "$server" | tee -a /tmp/bmMinerIps.txt
		echo "$server $MAC" | tee -a /tmp/bmMinerIpsMacs.txt
		echo "$server" > /tmp/bmminerIps.txt
	elif [[ $DESCR = $SG* ]]; then 
#		echo "$server" | tee -a /tmp/sgMinerIps.txt
		echo "$server $MAC" | tee -a /tmp/sgMinerIpsMacs.txt
		echo "$server" > /tmp/sgminerIps.txt
	elif [[ $DESCR = $CG* ]]; then 
#		echo "$server" | tee -a /tmp/cgMinerIps.txt
		echo "$server $MAC" | tee -a /tmp/cgMinerIpsMacs.txt
		echo "$server" > /tmp/cgminerIps.txt
	else
#		echo "$server is NOT a miner" | tee -a /tmp/notMiner.txt
		echo "$server $MAC NOT A MINER" | tee -a /tmp/notMinerMacs.txt
		echo "$server" > /tmp/notMinerIps.txt
	fi
done
#sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 fpingOutput > fping.sorted
#diff --changed-group-format="%>" --unchanged-group-format="" "zmap.sorted" "fping.sorted"

wc -l /tmp/*.txt
