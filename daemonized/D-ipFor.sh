#!/bin/bash
ip a show eth1 | grep -A8 -m1 MULTICAST|grep -m1 inet|cut -d' ' -f6
