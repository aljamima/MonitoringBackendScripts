!#/bin/bash

## gonna grab all the dhcp acks fom log files, sort them and then make a 
## database and/or array of values to check timestamp and verify it 
## grabbed an ip within last few minutes

#cat /var/log/syslog* |grep -i "DHCPACK" > acks.txt
#sort -sk1,2 acks.txt > sorted.acks
#oneline for that shizz..
cat /var/log/syslog* |grep -i "DHCPACK" |sort -sk1,2 > sorted.acks

