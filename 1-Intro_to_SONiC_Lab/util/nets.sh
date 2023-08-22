#!/bin/bash

sudo ip link set eth1 up
sudo ip link set eth2 up

sudo brctl addbr leaf01e32-host1
sudo brctl addbr leaf02e32-host2

sudo ip link set leaf01e32-host1 up
sudo ip link set leaf02e32-host2 up

sudo brctl addif leaf01e32-host1 eth1
sudo brctl addif leaf02e32-host2 eth2

sudo ip addr add 10.1.2.3/32 dev leaf01e32-host1
sudo ip addr add 10.1.3.3/32 dev leaf02e32-host2

sudo ip route add 10.1.2.0/24 dev leaf01e32-host1
sudo ip route add 10.1.3.0/24 dev leaf02e32-host2