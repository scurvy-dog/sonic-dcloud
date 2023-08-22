#!/bin/bash

export HOME=/home/cisco
cd /home/cisco/sonic-dcloud
git config --global --add safe.directory /home/cisco/sonic-dcloud
git pull

/1-Intro_to_SONiC_Lab/util/nets.sh