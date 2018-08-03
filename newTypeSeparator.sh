#!/bin/bash
sudo -v
rebootFlag="0"
[ -z "$1" ] || rebootFlag="1"
## USE THIS CHIT:
###    ssh root@10.2.1.82 '/sbin/reboot -f'
rm -f /tmp/*.txt 2>/dev/null
rm -f lowHash.txt
sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 ipList.txt > ips.sorted
function typeSeparator {
for server in $(<ips.sorted); do
	APISTATS=$(echo -n "stats" | nc -w 1 $server 4028 2>/dev/null | tr -d '\0')
	HASHRATE=`echo $APISTATS | sed -e 's/,/\n/g' | grep -a "GHS av" | cut -s -d "=" -f2`
	DESCR=$(echo $APISTATS | sed -e 's/,/\n/g' | grep -a "Description" | cut -d "=" -f2)
	BM="bm"
	SG="sg"
	CG="cg"
	if [[ $DESCR = $BM* ]]; then
		echo "$server" >> /tmp/bmMinerIps.txt
        	ninety="12.5"
		if [ -z "$HASHRATE" ]; then
	                continue
	        fi
	        if [[ $(echo "$HASHRATE > $ninety" | bc -l) -eq 0 ]]; then
	                LOW="$server HASHRATE IS LOW"
	        else
	                LOW=""
	        fi
	        [ -z "$LOW" ] || echo "$server" >> lowHash.txt
	elif [[ $DESCR = $SG* ]]; then
		echo "$server" >> /tmp/sgminerIps.txt
	elif [[ $DESCR = $CG* ]]; then
		echo "$server" >> /tmp/cgminerIps.txt
                ninety="200"
                if [ -z "$HASHRATE" ]; then
                        continue
                fi
                if [[ $(echo "$HASHRATE > $ninety" | bc -l) -eq 0 ]]; then
                        LOW="$server HASHRATE IS LOW"
                else
                        LOW=""
                fi
                [ -z "$LOW" ] || echo "$server" >> lowHash.txt
	else
		echo "$server" >> /tmp/notMinerIps.txt
	fi
done

}

typeSeparator

if [ "$rebootFlag" -ne 0 ]; then
	for each in $(<lowHash.txt); do
		sshpass -p admin ssh -o stricthostkeychecking=no root@$each '/sbin/shutdown -r 1 >/dev/null &'
		sshpass -p root ssh -o stricthostkeychecking=no root@$each '/sbin/shutdown -r 1 >/dev/null &'
		echo ""
	done
else
	echo "Reboot Flag Was NOT Set... "
	cat lowHash.txt
fi
wc -l /tmp/*.txt
wc -l lowHash.txt
