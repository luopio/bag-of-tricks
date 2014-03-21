Infrastructure
==============

This folder contains scripts and configuration files to get things like
reverse ssh, pulse monitor and 3g running.

Separate init scripts are used to start the actual working processes. This
makes it possible to make them run in the background and start/stop them like
regular services.

Scripts and configuration related to a certain piece of code stored outside 
of this folder should be stored there with the actual code.

init-scripts/ - files that work like regular init scripts (sh startup-script.sh start|stop).
                Usually expect the actual scripts to be run to be placed in /home/pi

scripts/ - actual script files that do the work. Usually controlled via init-scripts.

monit-rules/ - rules that can be copied under /etc/monit/conf.d to add into monitoring.
