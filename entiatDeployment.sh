#!/bin/bash


<<<<<<< HEAD
for server in $(<ipListDivision.txt); do
	minerIp=$server
	minerMac=$(./macFromIp.sh $server)
	#farmName=$(./justFarmDaemon.sh )
	farmName="Quincy-Division"
=======
for server in $(<ipList.txt); do
	minerIp=$server
	minerMac=$(./macFromIp.sh $server)
	farmName=$(./justFarmDaemon.sh )
	
>>>>>>> 84f903b7b4a7a44b794616c75fb365a1efef48fc
	
	#mysql -u root -p'Frostfiredragon1!!' minersdb -e "INSERT into miners (minerIp, macAddress, minerType, plocation, hashrate, maxTemp, farmName, numCards, uptime, poolUser, comments) VALUES ('10.1.1.1', 'AA:BB:CC:DD:EE:FF', 'type', '10.1.1.1', '122345', '99', 'Entiat', '6', 'uptime', 'user', 'NoComment')"
	mysql -u root -p'Frostfiredragon1!!' minersdb -e "INSERT into miners (minerIp, macAddress, farmName) VALUES ('$server', '$minerMac', '$farmName')"
done










#curl 'http://10.100.1.1/add.php' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Origin: http://10.100.1.1' -H 'Upgrade-Insecure-Requests: 1' -H 'Content-Type: application/x-www-form-urlencoded' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.62 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Referer: http://10.100.1.1/add.php' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.9,es-419;q=0.8,es;q=0.7,ru;q=0.6' -H 'Cookie: PHPSESSID=362b7r8306tt2lg5t6gk4jip07'
#--data 'minerIp=hjk&macAddress=kjh&minerType=kjh&plocation=jkh&hashrate=kjh&maxTemp=kjh&farmName=kj&numCards=h&uptime=kh&poolUser=kjh&comments=kjh&Submit=Add' --compressed
<<<<<<< HEAD

=======
>>>>>>> 84f903b7b4a7a44b794616c75fb365a1efef48fc
