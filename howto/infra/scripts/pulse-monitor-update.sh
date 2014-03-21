#!/bin/sh

# write the pidfile
echo $$ > /var/run/pulse-monitor.pid

while true
do

  DATE=`date --rfc-3339=ns`
  DATE=`date +%s`
  DATE=`date +%Y-%m-%dT%H:%M:%S`
  UPTIME=`uptime | sed 's/ /+/g'`
  CHECKS=`cat /citat-helsinki-count.txt`

  echo "Pulse monitor update on $DATE: "

  # run curl in the background to ensure that it does not crash this process
  curl "http://pulse-monitor.herokuapp.com/pulse?sent=`echo $DATE | sed 's/:/%3A/g'`&source=candymachine-1&param=$CHECKS" &

  sleep 5
done
