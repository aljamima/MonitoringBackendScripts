#!/bin/bash
###                                   TEST ON R-PI!!!
#### ThiS WILL ONLY MAP STATIC IPS!!! 
#
#    start script by scanning subnet into list1.txt prompt user to plug in first miner
#  scan network again until you find a new ip. ssh into it and set ifconfig 10.1.1.1 eth0
#  ifconfig eth0 10.1.1.1 netmask 255.0.0.0
#
#
export SSHPASS='admin'
rm -f dhcpEDITING.conf 2>/dev/null
touch dhcpEDITING.conf
function pause(){
 read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
}
function macFromIp () {
ping -c 1 -w 0.2 $1
arp -a $1 | awk '{print $4}'      # PASS THIS FUNCTION AN IP ADDRESS AND IT RETURNS MAC 
}


# nested-loop.sh: Nested "for" loops

total=0    #per shelf total for ending at 24 miners per rack
container=1   # set the second octet of ip here.
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
		mask="255.0.0.0"
	#	zmap -p 22 -i eth1 10.1.1.1/11 -o zmapOutput | sort -a
		echo "Scanning Network, Please Wait"

		echo "Ready To Map $ipVar to $position"
	#	echo "Please Press SpaceBar Once You Have Plugged In $position"
		pause
		echo "Looking For New Device..."
		fping -a -g 192.168.100.1 192.168.100.254 2>/dev/null | sort > out2.txt
#	fping -a -g 10.2.1.1/22 2>/dev/null | sort > out2.txt
		foundIp=$(diff <(sort out1.txt) <(sort out2.txt))
	#try somethin else...	foundIp=$(diff out1.txt out2.txt | grep -E '>*' | awk -F\> '{ print $2 }' | awk -F\< '{ print $1 }' | sed '/^\s*$/d')
		foundIp2=$(echo $foundIp | head -n1 | awk '{print $1;}')
		mac=$(macFromIp $foundIp2)
		postData $ipVar $position $mac
		echo "Miner was $foundIp, changing to $ipVar"
		echo $foundIp2 >> out1.txt
 	    sshpass -e ssh -o StrictHostKeyChecking=no root@$foundIp2 /sbin/ifconfig eth0 $ipVar netmask $mask && service networking restart
	#	pause
	done
  done
done    		
	
