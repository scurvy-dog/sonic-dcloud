#!/bin/bash

export HOME=/home/cisco
cd /home/cisco/sonic-dcloud
git config --global --add safe.directory /home/cisco/sonic-dcloud
git pull

/1-Intro_to_SONiC_Lab/util/nets.sh

date >> /home/cisco/util/boot-service.log
virsh start spine01 >> /home/cisco/util/boot-service.log
virsh start spine02 >> /home/cisco/util/boot-service.log

sleep 5

virsh start leaf01 >> /home/cisco/util/boot-service.log
virsh start leaf02 >> /home/cisco/util/boot-service.log

sleep 5

virsh list --all >> /home/cisco/util/boot-service.log