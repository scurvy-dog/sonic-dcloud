#!/bin/bash

sudo clab tools vxlan create --remote 172.10.10.104 --id 10 --link leaf-2-eth1
sudo clab tools vxlan create --remote 172.10.10.104 --id 20 --link leaf-2-eth2
sudo clab tools vxlan create --remote 172.10.10.103 --id 30 --link leaf-2-eth3
sudo clab tools vxlan create --remote 172.10.10.103 --id 40 --link leaf-2-eth4