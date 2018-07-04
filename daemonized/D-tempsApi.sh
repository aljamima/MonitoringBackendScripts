#!/bin/bash
hashStats=$(echo -n "stats+devs+summary+pools" | nc -w 1 $1 4028 | tr -d '\0')
temps=`echo $hashStats | sed -e 's/,/\n/g' | grep "temp*" | cut -d "=" -f2`
if [ -z "$temps" ]; then
	exit 1
fi
for each in $temps; do
	if [ "$each" != '0' ]; then
		#echo "$each is not zero"
		echo "$each" >> temps.txt 
	fi
	#echo "maybe $each IS zero"
	
done
cutNum=$(cat temps.txt | head -1)
new=$(cat temps.txt | sort -n | tail -n $cutNum)

rm temps.txt
echo "$new"
