- USE SOMETHING LIKE FOREVER TO KEEP IT RUNNING (https://github.com/nodejitsu/forever)

- IF YOU START NODE VIA /etc/rc.local USE SCREEN
Do not use nohup. You can't access nohup later. Do not "just start"
the service as it'll block the tty from allowing login (rc.local must
exit with 0!). Apt-get install screen.




