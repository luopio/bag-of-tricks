#!/bin/bash

case $1 in
   start)
      nohup /home/pi/autossh-reverse-tunnel.sh 0<&- &> /dev/null &
      echo $! > /home/pi/autossh-reverse-tunnel.pid
      ;;
    stop)  
      # pkill will handle all the children as well
      pkill -P `cat /home/pi/autossh-reverse-tunnel.pid` ;;
    *)  
      echo "usage: $0 {start|stop}" ;;
esac
exit 0
