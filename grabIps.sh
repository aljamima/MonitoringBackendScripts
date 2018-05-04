#!/bin/bash
sudo -v
clear
function rootCheck () {
if [[ $EUID -ne 0 ]]; then
	echo "THIS SCRIPT MUST BE RUN WITH SUDO PRIVILEGES"
	echo
	sleep 1
	echo "You Can Specify The Range You Want To Scan As An Argument At CLI: './grabIps.sh 10.2.1.1/22'"
	echo "CTRL + C If You Want To Specify A Range, Or Continue To Let Me Decide"
	exit 1
else 
	echo "You Can Specify The Range You Want To Scan As An Argument At CLI: './grabIps.sh 10.2.1.1/22'"
	echo "CTRL + C If You Want To Specify A Range, Or Continue To Let Me Decide"
fi

}
if [ -f /tmp/cidr.txt ] ; then
    rm /tmp/cidr.txt
    touch /tmp/cidr.txt
fi

if [ -f ipList.txt ] ; then
    rm ipList.txt
    touch ipList.txt
fi

if [ -f results.csv ] ; then
    rm results.csv
    touch results.csv
fi
rootCheck
if [ -z ${1+x} ]; then
	sudo fping -a -g $cidr 2>/dev/null >> results.csv
else
	sudo fping -a -g $1 2>/dev/null >> results.csv
fi
cidr=$(ip a show eth1 | grep -A8 -m1 MULTICAST|grep -m1 inet|cut -d' ' -f6)
echo "Running Fping Scan To Gather Ips..."

#zmap -B 10M -p 80 -n 10000 -o results.csv $cidr
