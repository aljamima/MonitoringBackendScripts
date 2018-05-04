#!/bin/bash
sudo -v ## extends time for sudo privileges after theyve been granted by initial run of script... defafults 5 mins but long runnning script or daemon might need more time
function removeTxtFiles () {
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
	rm -f gpuList.txt 2>/dev/null
	touch gpuList.txt
	rm -f defaultWorkers.txt 2>/dev/null
	touch defaultWorkers.txt
	rm -f errorList.txt 2>/dev/null
	touch errorList.txt
	#rm -f ipList.txt 2>/dev/null
	touch ipList.txt
	rm -f moHashratesMgt.txt 2>/dev/null
	touch moHashratesMgt.txt
	rm -f moHashratesGen.txt 2>/dev/null
	touch moHashratesGen.txt
}	
removeTxtFiles
echo "Running Fping Scan To Gather Ips..."
./grabIps.sh # sorts and pipes to 'ips.sorted' file
total=0
container=1
for rack in {1..9}; # of racks to loop thru ex: start..end
do
  rackTotal=0
  for shelf in {1..5};  # of shelves on the rack  ex: 1..5 means shelves start at 1 and go up to 5
  do
    for column in {1..4}    # NUMBER OF slots on the shelf. 
	do

		let "rackTotal+=1"
		let "total+=1"     
		if [ "$shelf" -eq 5 ] && [ "$column" -gt 4 ]  #this means it wont do any miners past shelf 5 - position 4. so only 24 rigs that rack
		then
			continue      # Skip rest of this particular loop iteration if its higher than number 24
	 	fi
		position="$container-$rack-$shelf-$column" # 1-1-1-1
		ipVar="10.$container.$rack.$rackTotal" # 10.x.x.x
		fping -a -g 192.168.100.1 192.168.100.254 2>/dev/null | sort > out2.txt
		foundIp=$(diff <(sort out1.txt) <(sort out2.txt))
	    foundIp2=$(echo $foundIp | head -n1 | awk '{print $1;}')
		mac=$(macFromIp $foundIp2)
		postData $ipVar $position $mac
		#sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 fpingOutput > fping.sorted
		#diff --changed-group-format="%>" --unchanged-group-format="" "zmap.sorted" "fping.sorted"
	done
  done
done
exit
