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

# Start ContainerLab Environment


# Create VXLAN Tunnels to Leaf-1 and Leaf-2
