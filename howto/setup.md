General setup instructions for Raspberry Pi
===========================================

Most projects requiring physical installation won't be accessible after deployment. Thus they need to be bomb-proof once they leave our office. Treat them like it was a NASA component being launched to outer space.

## Initial setup #
1. Fetch the latest Rasbpian distribution from: http://www.raspberrypi.org/downloads

2. Burn on SD Card

3. Boot the Pi
  - run the config, **expand the rootfs** to prevent out-of-diskspace errors in the future, set locale, set keyboard layout, change the pi user password if the system is accessible from outside

4. Run sudo apt-get update && sudo apt-get upgrade to get the latest packages on the system

5. Change /etc/motd (message-of-the-day) to describe what the system is about. Also add your name to make it easy to find the original developer. MOTD makes it easy to see what SD card does what.

## Setting up code #
1. All code needs to be placed under the home directory (/home/pi)

2. A README file is to be placed in the home directory. This file explains what this project is and needed commands (apt-get, etc) to setup the machine from the vanilla distribution. All relevant changes to configuration files should also be listed here.

2. The Pi should be ready to use on bootup without user intervention. This means that a startup script should be called from /etc/rc.local. **This script needs to return immediately** to allow logins. If your script hangs, the Pi won't allow anybody to login outside of SSH connections! Basically this means that all **code needs to run under a Unix Screen session**. Preferably call one script from /etc/rc.local (e.g. /home/pi/start_services.sh) and make sure this script just starts a bunch of screen sessions.  

## Testing ##
Beware that testing these physical devices takes a lot more time than webservices or apps in general. Since there are several different failing points from power adapter fluctuations to failing wires or electric components, it's best to test the whole package once assembled.

Due to the massive interdependencies present in any physical device, each - even minor - change in the hardware setup or running code should lead to new testing sessions. Treat each new setup as a new device. 

Create structured, identical tests. Once you have the device setup and working, pull the plug and reboot the device at least five times, each time noting if it device starts as desired without any error conditions.

Consider all angles. If you're using WiFi, change location and repeat five tests in a location where the reception might not be that good. If you know the final deployment location, it's best to test in similar locations or on the spot.

## Stability level #
Through repeated testing and usage we can start classifying our devices.

## Read through any additional documentation ##
To prevent you from repeating the errors of others and to speed up your work, several common tasks are described in separate setup_FEATURE files. Read them.
