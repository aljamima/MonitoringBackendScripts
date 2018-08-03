#!/bin/bash
prep="10.33."
pool1=$(curl 'https://api.ethermine.org/miner/0xFA26A582B2E133347a87fCBc62a28CAdA83161E8/workers/monitor'  |sed -e 's/,/\n/g' |grep -Eia 'worker|currentHashrate' |cut -d "{" -f2 |cut -d ":" -f2 >> file.in1)
pool2=$(curl 'https://api.ethermine.org/miner/0x598EE025add4A1a1B64b0976D6896520dc2BEd7a/workers/monitor'  |sed -e 's/,/\n/g' |grep -Eia 'worker|currentHashrate' |cut -d "{" -f2 |cut -d ":" -f2 >> file.in2)
pool3=$(curl 'https://api.ethermine.org/miner/0xaf088b41203627981c141978c19836fca1e24f72/workers/monitor'  |sed -e 's/,/\n/g' |grep -Eia 'worker|currentHashrate' |cut -d "{" -f2 |cut -d ":" -f2 >> file.in3)

paste -sd ' \n' file.in1 > file.out1
paste -sd ' \n' file.in2 > file.out2
paste -sd ' \n' file.in3 > file.out3

sed -i 's/\"//g' file.out*
sed -i 's/dot/./g' file.out*
counter=0
x="rig"
while IFS=" " read -r value1 value2 remainder
do
    value1=$(echo "$value1" | sed -e "s/^$x//")
    #echo  "$value1 is value1, $value2 is value2"
    [ ! -z $remainder ] && echo "$remainder is remainder of chitz"
    value3=$(bc -l <<< "$value2/1000000")
    hashes=${value3:0:6}
    mysql -u root '-pFrostfiredragon1!!' -h10.100.1.1 -D minersdb -e "UPDATE miners SET hashrate='$hashes' WHERE minerIp='$prep$value1'" && ((counter++))

done < "file.out1"

while IFS=" " read -r value1 value2 remainder
do
    value1=$(echo "$value1" | sed -e "s/^$x//")    
    #echo  "$value1 is value1, $value2 is value2"
    echo ""
    [ ! -z $remainder ] && echo "$remainder is remainder of chitz"
    value3=$(bc -l <<< "$value2/1000000")
    hashes=${value3:0:6}
    mysql -u root '-pFrostfiredragon1!!' -h10.100.1.1 -D minersdb -e "UPDATE miners SET hashrate='$hashes' WHERE minerIp='$prep$value1'" && ((counter++))


done < "file.out2"

while IFS=" " read -r value1 value2 remainder
do
    value1=$(echo "$value1" | sed -e "s/^$x//")
    #echo  "$value1 is value1, $value2 is value2"
    echo ""
    [ ! -z $remainder ] && echo "$remainder is remainder of chitz"
    value3=$(bc -l <<< "$value2/1000000")
    hashes=${value3:0:6}
    mysql -u root '-pFrostfiredragon1!!' -h10.100.1.1 -D minersdb -e "UPDATE miners SET hashrate='$hashes' WHERE minerIp='$prep$value1'" && ((counter++))


done < "file.out3"
echo "Count is $counter"

rm -rf file*
