#!/bin/bash
set -o functrace
clear
rm -f dhcpEDITING.conf 2>/dev/null
touch dhcpEDITING.conf
function hostEntry () {
	echo -e "host $1 {\\t fixed-address $3 ; \\thardware ethernet $2 ; } ## $TODAY" >> dhcpEditing.txt
}
function addip () {
	hostEntry $ipVar $macLine $ipVar >> dhcpdEDITING.conf
	#if dhcpd -t -cf /etc/dhcp/dhcpdEDITING.conf ; then
	#	sleep 3
	#	cp /etc/dhcp/dhcpdEDITING.conf /etc/dhcp/dhcpd.conf
	#	sudo systemctl restart isc-dhcp-server
	#	systemctl status isc-dhcp-server
	#else
	#	echo "THERE WERE ERRORS IN YOUR CONFIG, EXITING."
		#cp /etc/dhcp/dhcpdCOPY.conf /etc/dhcp/dhcpd.conf
	#	exit
	#fi
}
function macFromIp () {
arp -a $1 | awk '{print $4}'      # PASS THIS FUNCTION AN IP ADDRESS AND IT RETURNS MAC 
}
function line_Count {
	wc -l $1
}
function makeIpList {
	echo "Running Fping Scan To Gather IPs"
	sudo rm -rf ipList.txt 2>/dev/null
	fping -a -g 10.2.1.1 10.2.3.254 2>/dev/null > ipList.txt	
	echo "Done With Fping, Starting To Gather Worker Names"
}
function clearFiles {
	rm -f mgtList.txt 2>/dev/null
	touch mgtList.txt
	rm -f hashratesMgt.txt 2>/dev/null
	touch hashratesMgt.txt
	rm -f hashratesGenesis.txt 2>/dev/null
	touch hashratesGenesis.txt
	rm -f notMiner.txt 2>/dev/null
	touch notMiner.txt
	rm -f genList.txt 2>/dev/null
	touch genList.txt
	rm -f defaultWorkers.txt 2>/dev/null
	touch defaultWorkers.txt
	rm -f errorList.txt 2>/dev/null
	touch errorList.txt
	rm -f moHashratesMgt.txt 2>/dev/null
	touch moHashratesMgt.txt
	rm -f moHashratesGen.txt 2>/dev/null
	touch moHashratesGen.txt	
}

function grab_Hashrates_Genesis {
arrayNum=0
for server in $(<ipList.txt); do
	listNum=$(wc -l ipList.txt | awk '{print $1}')
	echo "server is $server"
	total=0    #per shelf total for ending at 24 miners per rack

			apistats=`echo -n "stats" | nc -w 1 $server 4028  | tr -d '\0'`
			hashStats=$(echo -n "stats" | nc -w 1 $server 4028 | tr -d '\0') ## had to add last tr part cuz of persistant warnings i couldnt redirect
			lessStats=$(echo -n "summary" | nc -w 1 $server 4028 | tr -d '\0')
			apistats=$(echo -n "summary+devs+pools+stats" | nc -w 1 $server 4028 | tr -d '\0')
		#	poolStats=`echo -n "pools" | nc $server 4028 2>/dev/null`
			MHASHRATE=$(echo $apistats | sed -e 's/,/\n/g' | grep "MHS av" | cut -d "=" -f2)     
			GHASHRATE=$(echo $hashStats | sed -e 's/,/\n/g' | grep "GHS av" | cut -d "=" -f2)

			HASHRATE=`echo $apistats | sed -e 's/,/\n/g' | grep "GHS av" | cut -d "=" -f2`
			BLADECOUNT=`echo $apistats | sed -e 's/,/\n/g' | grep "miner_count=" | cut -d "=" -f2`
			POOLS=`echo $apiStats | sed -e 's/,/\n/g' | grep "URL" | cut -d "=" -f2`
			TYPE=`echo $apiStats | sed -e 's/,/\n/g' | grep "Description" | cut -d "=" -f2`
			mType="S9_Miner"
			gHASHRATE=$(bc -l <<< "$HASHRATE/1000")
			hashes=$(echo $gHASHRATE | head -c 4)
			### echo -n "gpurestart|1" will restart gpu 1!!	## in DEVS: Msg=6 GPU(s)
			if [[ "$BLADECOUNT" -lt "3" ]]; then
				LOW="LOW HASHRATE -- 1 OR MORE CARDS DOWN"
			else
				LOW=""
			fi
			pos=$(./grabPositionValue.sh $arrayNum) # 1-1-1-1
			ipVar="10.$container.$rack.$rackTotal" # 10.x.x.x
			mac=$(macFromIp $server)
			echo "ghash $GHASHRATE mhash $MHASHRATE"
			echo "server is set to $server"
			echo "pos set to $pos"
			comments=$(date)
			temp=$(./tempsApi.sh $server | head -1)
			#echo "$server is $mType at: $hashes TH/s with $BLADECOUNT cards mining $LOW" >> hashratesMgt.txt
		    #### EVENTUALLY WE WILL MAKE THIS CONVERT GH INTO TH FOR READABILITy
			#beginString="curl 'http://localhost:3000/employees/save' -H 'Origin: http://localhost:3000' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9,es-419;q=0.8,es;q=0.7,ru;q=0.6' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: http://localhost:3000/employees/create' -H 'Connection: keep-alive' --data 'name=$server&mac=$mac&type=$mType&position=1-1-1-1&hashrate=$HASHRATE' --compressed"
			string="curl 'http://localhost/create.php' -H 'Cookie: PHPSESSID=g4ugbmd6hcte86lo72iain8prt' -H 'Origin: http://localhost' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9,es-419;q=0.8,es;q=0.7,ru;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: */*' -H 'Referer: http://localhost/index.php' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --data 'minerIp=$server&macAddress=$mac&minerType=$mType&plocation=$pos&hashrate=$GHASHRATE&comments=$comments&&Submit=Add' --compressed
#              --data 'name=$server&mac=$mac&type=$mType&position=1-1-1-1&hashrate=$HASHRATE' --compressed"       
			string2="curl 'http://localhost/edit.php' -H 'Cookie: PHPSESSID=g4ugbmd6hcte86lo72iain8prt' -H 'Origin: http://localhost' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9,es-419;q=0.8,es;q=0.7,ru;q=0.6' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: http://localhost/edit.php?id=3' -H 'Connection: keep-alive' --data 'minerIp=$server&macAddress=$mac&minerType=$mType&plocation=$pos&hashrate=$GHASHRATE&comments=$comments&Submit=Add' --compressed"
			string3="curl 'http://localhost/add.php' -H 'Cookie: PHPSESSID=g4ugbmd6hcte86lo72iain8prt' -H 'Origin: http://localhost' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9,es-419;q=0.8,es;q=0.7,ru;q=0.6' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: http://localhost/add.php' -H 'Connection: keep-alive' --data 'minerIp=$server&macAddress=$mac&minerType=$mType&plocation=$pos&hashrate=$GHASHRATE&comments=$comments&Submit=Add' --compressed"

			eval $(echo $string3)
			let "rackTotal+=1"
			let "total+=1"
			let "arrayNum+=1"
done
}

clearFiles
## function to clear old list and create new one. comment out for faster testing
#makeIpList 

ARRAY=$(cat ipList2.txt)
#grab_Hashrates_Mgt
grab_Hashrates_Genesis


echo ""
wc -l ipList.txt
wc -l mgtList.txt
wc -l genList.txt
wc -l notMiner.txt
echo "cat hashratesMgt.txt -OR- cat hashratesGenesis.txt "


