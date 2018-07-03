#!/bin/bash
export SSHPASS='poopoo11'
grepper=$1

hostname=$(sshpass -e ssh script@10.0.0.5 hostname)
echo "$hostname"
