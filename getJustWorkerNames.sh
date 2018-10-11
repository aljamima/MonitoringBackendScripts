#!/bin/sh
export SSHPASS="poopoo11"

sshpass -e scp script@10.0.0.5:/home/shawnm/divisionIpList.txt ./macIp.txt

cat macIp.txt |awk '{print $1;}' > justIp.txt  

for checks in $(<justIp.txt); do
apistats=$(echo -n "pools+devs+summary+stats" | nc -w 1 $checks 4028 2>/dev/null)
worker=$(echo -n $apistats | sed -e 's/,/\n/g' | grep -a "User" | cut -d "=" -f2)
worker=$(echo $worker |awk '{print $1;}')
echo "$checks $worker" |tee -a finList.txt
done



