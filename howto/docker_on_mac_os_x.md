= Notes on installing Docker on Mac OS X

== Installation

brew install docker
brew install boot2docker

boot2docker init
boot2docker up
# export DOCKER_HOST=tcp://localhost:4243

# we need to forward ze ports from VM to HOST
for i in {49000..49900}; do
 VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port$i,tcp,,$i,,$i";
 VBoxManage modifyvm "boot2docker-vm" --natpf1 "udp-port$i,udp,,$i,,$i";
done

# $ ./boot2docker ssh
# User: docker
# Pwd:  tcuser

# Updating your local Linux VM
# $ boot2docker stop
# $ boot2docker download
# $ boot2docker start

== Hello world
docker pull busybox
docker run busybox /bin/echo hello maailma
docker run busybox /bin/uname -a

== Port forward

Run your docker with docker run -p 80 and check which >49000 port gets mapped to 80 on container,
or do -p 80:80 and run stuff below for VM redirect

Access port 80 on container from 49000
boot2docker ssh -L 49000:localhost:80
