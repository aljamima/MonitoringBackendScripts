#!/bin/bash
export SSHPASS='poopoo11'
grepper=$1

hostname=$(sshpass -e ssh -o StrictHostKeyChecking=no script@10.5.1.1 hostname)
echo "$hostname"
