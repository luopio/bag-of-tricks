#!/bin/bash

case $1 in
   start)
      sleep 5 && nohup /home/pi/ssh-reverse-tunnel.sh 0<&- &> /dev/null &
      echo $! > /home/pi/ssh-reverse-tunnel.pid
      ;;
    stop)  
      # pkill will handle all the children as well
      pkill -P `cat /home/pi/ssh-reverse-tunnel.pid` ;;
    *)  
      echo "usage: $0 {start|stop}" ;;
esac
exit 0
