#!/bin/bash
### call this script as 'timeout 1 ./ipFromMac.sh AB:CD:EF
mac=$(echo $1 | awk '{print tolower($0)}')
function ipFromMac () {
ip=$(arp -a | grep $mac)
echo ""
if [ -z ${ip+x} ]; then
        fping -a -g 10.2.1.1/22 2>/dev/null
        resolve=$(echo "$ip" | awk '{print $2}')      # PASS THIS FUNCTION AN IP ADDRESS AND IT RETURNS MAC 
#        new=$(echo $resolved | tr -d '()')
        BEST=$(echo ${resolve:1:-1})
        echo $BEST
else
        resolve=$(echo "$ip" | awk '{print $2}')      # PASS THIS FUNCTION AN IP ADDRESS AND IT RETURNS MAC 
#        new=$(echo $resolved | tr -d '()')
        BEST=$(echo ${resolve:1:-1})
        echo $BEST
fi
export SSHPASS='poopoo11'
grepper=$1

newIp=$(sshpass -e ssh script@10.0.0.5 cat /var/log/syslog | grep -i $grepper | head -1 | awk '{print $8}' | tr -d '\0')
if [ -z ${newIp+x} ]; then
        newIp=$(sshpass -e ssh script@10.0.0.5 cat /var/log/syslog.1 | grep -i $grepper | head -1 | awk '{print $8}'  | tr -d '\0')
fi
echo "$newIp"

}
resolved=$(ipFromMac $mac)
echo $resolved
exit
