#!/bin/bash

# shamelessly ripped from http://mmonit.com/wiki/Monit/FAQ#pidfile

export JAVA_HOME=/usr/local/java/
CLASSPATH=ajarfile.jar:.

case $1 in
   start)
      echo $$ > /var/run/xyz.pid;
      exec 2>&1 java -cp ${CLASSPATH} org.something.with.main 1>/tmp/xyz.out 
      ;;
    stop)  
      kill `cat /var/run/xyz.pid` ;;
    *)  
      echo "usage: xyz {start|stop}" ;;
esac
exit 0
