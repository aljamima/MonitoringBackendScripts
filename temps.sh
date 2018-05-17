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
#sed -i '$ d' temps.txt  #MAYBE REMOVE LAST LINE AFTER PRINTING HIGH TEMP, THEN RUN AGAIN FOR $cutNum TIMES....
#new2=$(cat temps.txt | sort -n | tail -n 1)
#sed -i '$ d' temps.txt  #MAYBE REMOVE LAST LINE AFTER PRINTING HIGH TEMP, THEN RUN AGAIN FOR $cutNum TIMES....
#new3=$(cat temps.txt | sort -n | tail -n 1)


rm temps.txt
echo "$1:"
echo "$new $new2 $new3 is highest temps, number of cards is: $cutNum"
echo ""


# this will remove last line and print it. maybe try it cutNum times?
#  tail -n 1 "$file" | tee >(wc -c | xargs -I {} truncate "$file" -s -{})
