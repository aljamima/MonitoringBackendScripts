#!/bin/bash
echo "Running Hashrate Updater"
time ./justHashrateDaemon.sh
echo "Running Temps Updater"
time ./justTempsDaemon.sh
echo "Running Temps Updater"
time ./justWorkerDaemon.sh
echo "Running Worker Updater"
time ./justFarmDaemon.sh
echo "ALL DONE UPDATING DATABASE ENTRIES!!"
