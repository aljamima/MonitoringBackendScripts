#!/bin/bash
outlet=$1
pduIp="10.11.1.1"
/usr/bin/expect <<EOD
spawn telnet $pduIp
expect "Username:"
send "admn\r"
expect "Password:"
send "admn\r"
expect "Switched CDU:"
sleep 1
send "reboot\r"
sleep 1
expect "Outlet or Group Name:"
send "$outlet\r"
sleep 5
EOD
