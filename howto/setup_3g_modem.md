QUICK NOTES ON SETTING UP 3G
============================

sudo apt-get install wajig # :)
wajig install -y ppp

wget "http://www.sakis3g.org/versions/latest/armv4t/sakis3g.gz"
gunzip sakis3g.gz
chmod +x sakis3g
sudo ./sakis3g --interactive


# Extra steps needed for Huawei E353 (black DNA stick) and possibly
# others that mount as USB sticks by default

wajig install usb-modeswitch

lsusb # tells you vendorID and productID

# works for E353, dunno about what the message-content is. Might take a while to work (< 5 min)
sudo usb_modeswitch -b2 -W -v 12d1 -p 151a -n --message-content 555342437f0000000002000080000a11062000000000000100000000000000

# lsusb should now list a different ID:
# Bus 001 Device 012: ID 12d1:14ac Huawei Technologies Co., Ltd. 

# run sakis3g
