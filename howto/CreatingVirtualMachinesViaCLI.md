How to create virtual machines via SSH (or CLI)
===============================================

Commands used to setup Ubuntu Server v 12.04 on Virtualbox 4.2. 

    $ vboxmanage createvm --name "Ubuntu Server 12.04" --ostype Ubuntu --register
    $ vboxmanage modifyvm "Ubuntu Server 12.04" --boot1 dvd --nic1 nat
    # 50 GB
    $ vboxmanage createhd --filename "UbuntuServer1204.vdi" --size 50000
    $ vboxmanage storagectl "Ubuntu Server 12.04" --name "IDE Controller" --add ide --controller PIIX4
    $ vboxmanage storageattach "Ubuntu Server 12.04" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium UbuntuServer1204.vdi 
    $ vboxmanage storageattach "Ubuntu Server 12.04" --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium UbuntuServer1204.iso
    
Installation happens here...

    $ vboxmanage storageattach "Ubuntu Server 12.04" --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium none
    # HTTP: redirect 8000 on host to 80 on guest
    $ vboxmanage modifyvm "Ubuntu Server 12.04" --natpf1 "guesthttp2,tcp,,8000,,80"
    # SSH: redirect 2222 from host to 22 on guest 
    $ vboxmanage modifyvm "Ubuntu Server 12.04" --natpf1 "guestssh,tcp,,2222,,22"


You might also need something like

    $ sudo ufw allow 8000/tcp

to poke holes in the host firewall

Starting the VM in headless mode (RDP enabled by default, VNC optional):

    $ vboxheadless --startvm "Ubuntu Server 12.04"


Good Vbox manual pages:

http://www.virtualbox.org/manual/ch07.html#idp55502880
http://www.virtualbox.org/manual/ch06.html#natforward
