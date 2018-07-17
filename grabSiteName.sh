#!/bin/bash
export SSHPASS='poopoo11'
grepper=$1

hostname=$(sshpass -e ssh -o StrictHostKeyChecking=no script@10.0.0.5 hostname)
echo "$hostname"
