#!/bin/bash

sudo clab tools vxlan create --remote 172.10.10.103 --id 10 --link leaf-1-eth1
sudo clab tools vxlan create --remote 172.10.10.103 --id 20 --link leaf-1-eth2
sudo clab tools vxlan create --remote 172.10.10.104 --id 30 --link leaf-1-eth3
sudo clab tools vxlan create --remote 172.10.10.104 --id 40 --link leaf-1-eth4