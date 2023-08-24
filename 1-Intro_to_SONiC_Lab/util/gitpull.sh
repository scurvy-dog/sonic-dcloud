#!/bin/bash

date >> /home/cisco/util/boot-service.log

# gitpull
echo "git pull" > /home/cisco/util/boot-service.log
export HOME=/home/cisco
cd /home/cisco/sonic-dcloud
git config --global --add safe.directory /home/cisco/sonic-dcloud
git pull > /home/cisco/util/boot-service.log

# nets
echo "create endpoint bridges and routes" > /home/cisco/util/boot-service.log
sudo brctl addbr leaf01-host1
sudo brctl addbr leaf02-host2

#sudo ip link set mgt-net up
sudo ip link set leaf01-host1 up
sudo ip link set leaf02-host2 up

sudo brctl addif leaf01-host1 eth1
sudo brctl addif leaf02-host2 eth2

sudo ip addr add 10.1.2.3/32 dev leaf01-host1
sudo ip addr add 10.1.3.3/32 dev leaf02-host2

sudo ip route add 10.1.2.0/24 dev leaf01-host1
sudo ip route add 10.1.3.0/24 dev leaf02-host2

# Virsh
echo "virsh start sonic VMs" > /home/cisco/util/boot-service.log
virsh start spine01 > /home/cisco/util/boot-service.log
virsh start spine02 > /home/cisco/util/boot-service.log

sleep 5

virsh start leaf01 > /home/cisco/util/boot-service.log
virsh start leaf02 > /home/cisco/util/boot-service.log

sleep 5

virsh list --all > /home/cisco/util/boot-service.log