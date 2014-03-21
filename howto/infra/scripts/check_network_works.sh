#!/bin/sh 

ping -w 3 -c 1 facebook.com >> /dev/null
RETVAL=$?

if [ $RETVAL -eq 0 ]; then
  echo "works"
else
  echo "does not work"

  # needs both down and up. Just up w/ force can lead to Terminated processes
  ifdown wlan0
  
  # discovered that sometimes unloading the module is needed
  if [ $( lsmod | grep r8712u | wc -l ) -gt 0 ]; then
    echo "... reloading kernel module"
    modprobe -r r8712u
    sleep 1
    modprobe r8712u
  fi

  ifup --force wlan0

  # make note of when failed
  date "+%H:%M:%S %d.%m.%Y" >> /restarted_network.txt
fi
