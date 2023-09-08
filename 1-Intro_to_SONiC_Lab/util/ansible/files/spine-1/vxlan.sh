#!/bin/bash

sudo clab tools vxlan create --remote 172.10.10.101 --id 10 --link spine-1-eth1
sudo clab tools vxlan create --remote 172.10.10.101 --id 20 --link spine-1-eth2
sudo clab tools vxlan create --remote 172.10.10.102 --id 30 --link spine-1-eth3
sudo clab tools vxlan create --remote 172.10.10.102 --id 40 --link spine-1-eth4