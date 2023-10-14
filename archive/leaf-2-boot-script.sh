#!/bin/bash

date > /home/cisco/util/boot-service.log

# gitpull
echo "
git pull" >> /home/cisco/util/boot-service.log

export HOME=/home/cisco
cd /home/cisco/sonic-dcloud
git config --global --add safe.directory /home/cisco/sonic-dcloud
git pull >> /home/cisco/util/boot-service.log

# nets
echo "
create endpoint bridges and routes, brctl show" >> /home/cisco/util/boot-service.log

sudo brctl addbr leaf02-host2
sudo ip link set leaf02-host2 up
sudo brctl addif leaf02-host2 ens224
sudo ip addr add 198.18.12.254/24 dev leaf02-host2
sudo ip route add 198.18.11.0/24 via 198.18.12.1

brctl show >> /home/cisco/util/boot-service.log
ip route >> /home/cisco/util/boot-service.log


# Start ContainerLab Environment


# Create VXLAN Tunnels to sonic-rtr-leaf-1 and sonic-rtr-leaf-2
