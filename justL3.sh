#!/bin/bash
export SSHPASS='live'

if [ -f ipList.txt ] ; then
    rm ipList.txt
    touch ipList.txt
fi
if [ -f hashratesL3.txt ] ; then
    rm hashratesL3.txt
    touch hashratesL3.txt
fi
if [ -f moHashrates.txt ] ; then
    rm moHashrates.txt
    touch moHashrates.txt
fi
echo "Running Fping Scan To Gather Ips..."
fping -a -g 10.2.0.0 10.2.3.254 2>/dev/null > ipList.txt
l3Count=0
s9Count=0
notMiner=0
for server in $(<ipList.txt);
do
	hashStats=$(echo -n "stats" | nc -w 1 $server 4028 | tr -d '\0') ## had to add last tr part cuz of persistant warnings i couldnt redirect
	lessStats=$(echo -n "summary" | nc -w 1 $server 4028 | tr -d '\0')
	apistats=$(echo -n "summary+devs+pools+stats" | nc -w 1 $server 4028 | tr -d '\0')
#	poolStats=`echo -n "pools" | nc $server 4028 2>/dev/null`
	MHASHRATE=$(echo $apistats | sed -e 's/,/\n/g' | grep "MHS av" | cut -d "=" -f2)     
	GHASHRATE=$(echo $hashStats | sed -e 's/,/\n/g' | grep "GHS av" | cut -d "=" -f2)
#	THASHRATE=`echo $apistats | sed -e 's/,/\n/g' | grep "THS av" | cut -d "=" -f2`
	POOLS=$(echo $apistats | sed -e 's/,/\n/g' | grep "URL" | cut -d "=" -f2)
	TYPE=$(echo $hashStats | sed -e 's/,/\n/g' | grep "Type" | cut -d "=" -f2)   # will tell me S9 or L3 if i grep for it...
	BLADECOUNT=`echo $apistats | sed -e 's/,/\n/g' | grep "miner_count=" | cut -d "=" -f2`
#	FREQ=`echo $apistats | sed -e 's/,/\n/g' | grep "frequency" | cut -d "=" -f2`
#	FAN1=`echo $apistats | sed -e 's/,/\n/g' | grep "fan1=" | cut -d "=" -f2`
#	FAN3=`echo $apistats | sed -e 's/,/\n/g' | grep "fan3=" | cut -d "=" -f2`
#	HWPERCENT=`echo $apistats | sed -e 's/,/\n/g' | grep "Hardware%" | cut -d "=" -f2` #HW errors
	s9="S9"
	l3="L3"
	pools=$( echo $POOLS | awk '{print $1}')
	twelve=12
#	if [[ $(echo "$HASHRATE > $twelve" | bc -l) -eq 0 ]]; then
#	 min=$(echo 12.45 10.35 | awk '{if ($1 < $2) print $1; else print $2}')
#		LOWHASH=" *** HASHRATE IS LOW"
#	else
##	fi
	if [[ $TYPE = *"S9"* ]]; then
		if [[ "$BLADECOUNT" -lt "3" ]]; then
		LOWCARD="LOW HASHRATE -- 1 OR MORE CARDS DOWN"
		else
		LOWCARD=""
		fi
		mType="Antminer S9"
		let "s9Count+=1"
		echo "$checks" >> mgtList.txt
#		grab_Hashrates_Mgt $checks
	elif [[ $TYPE = *"L3"* ]]; then
		if [[ "$BLADECOUNT" -lt "4" ]]; then
			LOWCARD="LOW HASHRATE -- 1 OR MORE CARDS DOWN"
		else
			LOWCARD=""
		fi
		mType="Antminer L3"
		let "l3Count+=1"
		echo "$checks" >> genList.txt
#		grab_Hashrates_Genesis $checks
	else
		let "notMiner+=1"
		echo "$checks is NOT a miner" >> notMiner.txt
	fi	
	if [ -z $HASHRATE ]; then
		continue
	fi
	mac=$(timeout 1 ./macFromIp.sh $server)
	echo "$server is an $mType $mac With $MHASHRATE $GHASHRATE hashes, using pool: $pools  *** $LOWCARD" | tee -a hashratesL3.txt

done
echo "$s9Count S9's UP"
echo "$l3Count L3's UP"
echo "$notMiner IPs that arent miners"
exit
