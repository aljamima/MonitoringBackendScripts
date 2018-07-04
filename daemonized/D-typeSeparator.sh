#!/bin/bash
sudo -v
##    WE CAN SEPERATE BY SOFTWARE MINER IS RUNNING... 'bmMiner' for S9, 'gmMiner' for Genesis GPU, 'cgMiner' for the L3
##
rm -f results.csv 2>/dev/null
touch results.csv
rm -f ips.sorted 2>/dev/null
touch ips.sorted
sudo rm -rf /tmp/*.txt 2>/dev/null

sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 ipList.txt > ips.sorted
for server in $(<ips.sorted); do
	APISTATS=$(echo -n "stats+summary" | nc -w 1 $server 4028 2>/dev/null | tr -d '\0')
	DESCR=$(echo -n $APISTATS | sed -e 's/,/\n/g' | grep "Description" | cut -d "=" -f2)
	#MAC=$(timeout 1 ./macFromIp.sh $server)
	BM="bm"
	SG="sg"
	CG="cg"
	#if [ -z ${MAC+x} ]; then
	#	echo "$server Is Causing Problems" | tee -a /tmp/notMinerMacs.txt
	#	continue
	#fi
	if [[ $DESCR = $BM* ]]; then
#		echo "$server" | tee -a /tmp/bmMinerIps.txt
		#echo "$server $MAC" | tee -a /tmp/bmMinerIpsMacs.txt
		echo "$server" >> /tmp/bmminerIps.txt
	elif [[ $DESCR = $SG* ]]; then 
#		echo "$server" | tee -a /tmp/sgMinerIps.txt
		#echo "$server $MAC" | tee -a /tmp/sgMinerIpsMacs.txt
		echo "$server" >> /tmp/sgminerIps.txt
	elif [[ $DESCR = $CG* ]]; then 
		if [[ $(nmap -p 80 --script http-title $server |grep -iq "dragonmint") -eq 0 ]]; then 
			echo "$server" >> /tmp/dragonMintIps.txt
			#echo "$server $MAC" | tee -a /tmp/dragonMintIpsMacs.txt
		else
			echo "$server" >> /tmp/cgMinerIps.txt
			#echo "$server $MAC" | tee -a /tmp/cgMinerIpsMacs.txt
		fi
	else
#		echo "$server is NOT a miner" | tee -a /tmp/notMiner.txt
		#echo "$server $MAC NOT A MINER" | tee -a /tmp/notMinerMacs.txt
		echo "$server" >> /tmp/notMinerIps.txt
	fi
done

wc -l /tmp/*.txt
