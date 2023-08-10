#!/bin/bash

sudo brctl addbr leaf01e32-host1
sudo brctl addbr leaf02e32-host2

sudo ip link set leaf01e32-host1 up
sudo ip link set leaf02e32-host2 up