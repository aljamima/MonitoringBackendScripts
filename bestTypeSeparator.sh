#!/bin/bash

rm -rf /tmp/*.txt 2>/dev/null

for server in $(<ipListColumbia.txt); do
        APISTATS=$(echo -n "summary" | nc -w 1 $server 4028 2>/dev/null | tr -d '\0')
        HASHRATE=$(echo $APISTATS | sed -e 's/,/\n/g' | grep -a "GHS av" | cut -s -d "=" -f2)
        DHASHRATE=$(echo $APISTATS | sed -e 's/,/\n/g' | grep -a "MHS av" | cut -s -d "=" -f2 | head -n 1)
        DESCR=$(echo $APISTATS | sed -e 's/,/\n/g' | sed -e 's/|/\n/g' | grep -ia "Description" | cut -d "=" -f2)
        TYPE=$(echo -n "stats" | nc -w 1 $server 4028 | sed -e 's/,/\n/g' | sed -e 's/|/\n/g' | grep -ia "type" | head -n 1 | cut -d "=" -f2)
	MAC=$(timeout 1 ./macFromIp.sh $server)
	BM="bm"
        SG="sg"
        CG="cg"
        if [ -z ${MAC+x} ]; then
                echo "$server Is Causing Problems" | tee -a /tmp/notMinerMacs.txt
                continue
        fi
		#TITLE=$(wget -qO- '$server' | perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si')
        TITLE=$(curl --connect-timeout 5 -s $server | grep -o "<title>[^<]*" | cut -d'>' -f2-)
        if [ -z "$HASHRATE" ] && [ ! -z "$DHASHRATE" ]; then
                HASHRATE=$(bc -l <<< "$DHASHRATE/1000000")
        else
                touch poop
                #HASHRATE=$(bc -l <<< "$HASHRATE/1000")
        fi
        HASHRATE=${HASHRATE:0:5} 
        if [[ $DESCR = $BM* ]]; then
                echo "$server $MAC $HASHRATE $TYPE" | tee -a /tmp/bmMinerIpsMacs.txt
        elif [[ $DESCR = $SG* ]]; then 
                echo "$server $MAC $HASHRATE $TYPE" | tee -a /tmp/sgMinerIpsMacs.txt
        elif [[ $DESCR = $CG* ]]; then
		if [ -z "$TYPE" ]; then
			TYPE="$TITLE"
		fi
                echo "$server $MAC $HASHRATE $TYPE" | tee -a /tmp/cgMinerIpsMacs.txt
        else
                echo "$server $MAC $HASHRATE NOT A MINER" | tee -a /tmp/notMinerMacs.txt
        fi
done
wc -l /tmp/*.txt
exit 0
