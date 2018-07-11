#!/bin/bash
#clear
#DEFAULTWORKER="Mgtbtc2.QuincyMiner"

#line_Count() {
#	wc -l $1
#}
#rm -f mgtList.txt 2>/dev/null
#touch mgtList.txt
#rm -f hashratesMgt.txt 2>/dev/null
#touch hashratesMgt.txt
#rm -f hashratesGenesis.txt 2>/dev/null
#touch hashratesGenesis.txt
#rm -f notMiner.txt 2>/dev/null
#touch notMiner.txt
#rm -f genList.txt 2>/dev/null
#touch genList.txt
#rm -f defaultWorkers.txt 2>/dev/null
#touch defaultWorkers.txt
#rm -f errorList.txt 2>/dev/null
#touch errorList.txt

#echo "Running Fping Scan To Gather IPs"
#fping -a -g 192.168.0.11 192.168.0.254 2>/dev/null > ipList.txt       #Uncomment this line for a 192.* network
#fping -a -g 10.2.0.0 10.2.3.255 2>/dev/null > ipList.txt           #Uncomment this line for a 10.* network 
#echo "Done With Fping, Starting To Gather Worker Names"
checks=$1
APISTATS=`echo -n "pools" | nc -w 1 $checks 4028`
#BM="bm"
#SG="sg"
#POOLS=`echo $APISTATS | sed -e 's/,/\n/g' | grep "URL" | cut -d "=" -f2`
#DESCR=`echo $APISTATS | sed -e 's/,/\n/g' | grep "Description" | cut -d "=" -f2`
WORKER=`echo $APISTATS | sed -e 's/,/\n/g' | grep "User" | cut -d "=" -f2`
#if [[ $DESCR = $BM* ]]; then
#	echo "$checks is using worker $WORKER" | tee -a  tee /workerNames/mgtWorkers_$(date '+%Y-%m-%d-%H').txt
#elif [[ $DESCR = $SG* ]]; then
#	
#	echo "$checks is using worker $WORKER at URL: $POOLS" | tee -a genList.txt		
#else
#	echo "$checks isnt a miner. prolly" | tee -a notMiner.txt
#fi
#echo "To See Results Cat mgtList.txt or genList.txt"
#line_Count mgtList.txt
#echo -n "has lines in the file" 
#echo ""
#line_Count genList.txt
#echo -n "has lines in the file" 
#echo ""
#line_Count notMiner.txt
#echo -n "has lines in the file" 
######   REMOVE ALL LINES ENDING IN WORKER!!!!
#find /home/shawnm/workerNames/* -mtime +30 -exec rm {} \;
#currentIp=$(mysql -ss -u root -p'Frostfiredragon1!!' -Dminersdb -e "SELECT id FROM miners WHERE minerIp='$checks';")
#connector="mysql -u root -p'Frostfiredragon1!!' -Dminersdb -e "
#updateHash="\"UPDATE miners SET poolUser='$WORKER' WHERE id='$id';\""
#hashConcat="$connector $updateHash"
#eval $(echo mysql -u root -p'Frostfiredragon1!!' -Dminersdb -e "$updateHash")
echo "$WORKER"
exit 0
