#!/bin/bash

NOW=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="info_$NOW.txt"

declare -a DS_SERVERS=("ds1" "ds2" "ds3" "ds4" "ds5" "ds6" "ds7" "ds8")

echo "############# START METRICS1 #############" >> $LOG_FILE 
ssh -t metrics1 "/ds/burn-in/metrics/bin/status 2>&1" >> $LOG_FILE
echo "############# END METRICS1 #############" >> $LOG_FILE

echo "############# START PROXY1 #############" >> $LOG_FILE 
ssh -t proxy1 "/ds/burn-in/proxy/bin/status 2>&1" >> $LOG_FILE
echo "############# END PROXY1 #############" >> $LOG_FILE


for i in "${DS_SERVERS[@]}"
do
   echo "############# START $i #############" >> $LOG_FILE 
   ssh -t $i "
             java -jar /home/centos/bin/WhatsRunning.jar 2>&1
             free -h 2>&1
             df -h 2>&1
             ls /ds/burn-in/ds/*.hprof 2>&1
             /ds/burn-in/ds/bin/status 2>&1
             /ds/burn-in/ds/bin/dsreplication status -a -S 2>&1
             ls /ds/burn-in/ds/logs/work-queue-backlog-thread-dump-*.log 2>&1
             ls /ds/burn-in/ds/logs/lock-conflict-details-conn--10-op-*.log 2>&1
             ls /ds/burn-in/ds/logs/expensive-operation-dump-*.log 2>&1
             grep SEVERE /ds/burn-in/ds/logs/errors* 2>&1
             grep FATAL /ds/burn-in/ds/logs/errors* 2>&1
             ls /ds/burn-in/CSD* 2>&1
             " >> $LOG_FILE
   echo "############# END $i #############" >> $LOG_FILE
done
