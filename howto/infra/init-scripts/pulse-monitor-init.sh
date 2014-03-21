#!/bin/bash

case $1 in
   start)
      nohup /home/pi/pulse-monitor-update.sh 0<&- &> /dev/null &
      # start-stop-daemon --start --name pulse-monitor-update.sh --pidfile /var/run/pulse-monitor.pid --startas /home/pi/pulse-monitor-update.sh --
      ;;
    stop)  
      # make sure the start command created the pid
      kill `cat /var/run/pulse-monitor.pid` ;;
    *)  
      echo "usage: pulse-monitor-init.sh {start|stop}" ;;
esac
exit 0
