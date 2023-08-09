# Welcome to the SONiC on Cisco 8000 Emulator Lab

### Description: This repository contains lab guide, router configs, setup scripts, and other code for running through the lab.

SONiC is an open source network operating system based on Linux that runs on switches/routers from multiple vendors and ASICs. SONiC offers a full-suite of network functionality, like BGP, that has been production-hardened in the data centers of some of the largest cloud-service providers.

Though it is easy to run SONiC in a virtualized lab environment, what this lab brings is the ability to run SONiC on a platform that emulates the Cisco 8000 hardware. That allows for data-plane feature enablement such as QoS, hardware counters, and debug tools. 

The lab software stack is built off the SONiC master build with Cisco specific platform drivers for the Cisco 8000 hardware.

## Contents
* Repository Overview [LINK](#repository-overview)
* Lab Topology [LINK](#lab-topology)
* Remote Access [LINK](#remote-access)
* Project Jalapeno [LINK](#jalapeno)
* Lab 1 - XRd Topology Setup and Validation [LINK](/lab_1/lab_1-guide.md)
* Lab 2 - Config Baseline SR-MPLS and SRv6 [LINK](/lab_2/lab_2-guide.md)
* Lab 3 - Config SRv6 L3VPN with TE [LINK](/lab_3/lab_3-guide.md)
* Lab 4 - Config BMP and install Jalapeno [LINK](/lab_4/lab_4-guide.md)
* Lab 5 - A Tour of Jalapeno [LINK](/lab_5/lab_5-guide.md)
* Lab 6 - Build Your Own Cloud-Native SDN [LINK](/lab_6/lab_6-guide.md)


## Github Repository Overview
Each of the labs is designed to be completed in the order presented. Lab 1 is the baseline configurations 
needed to build the starting topology and launch the XRd and extended environment.

### Root Directory

| File Name                | Description                                                    |
|:-------------------------|:---------------------------------------------------------------|
| host_check               | Runs an analysis verify whether XRd can run on your host       |
| xr-compose               | Inputs a defined XRD YAML file and creates docker compose file |

```
Example:
./xr-compose -f docker-compose-lab_1.yml -li ios-xr/xrd-control-plane:7.8.1
```

### Individual Lab Directories
Within each lab directory you should see several files of importance:
(X = lab #)

| File Name                | Description                                                  |
|:-------------------------|:-------------------------------------------------------------|
| cleanup-lab_X.sh         | Cleans up the docker environemnt                             |
| docker-compose-lab_X.yml | YAML input file used by docker compose to build the topology |
| lab_X-topology.yml       | YAML input file for XRD to create docker compose file        |
| lab_X-guide.md           | User guide for this lab                                      |
| setup-lab_X.sh           | Calls cleanup script, launches the topology, creates utils   | 


General instructions for building and running XRd topologies on bare-metal, VMs, AWS, etc. can be found here:
https://github.com/brmcdoug/XRd

## CLEUR Lab Session LTSPG-2212 Cisco dCloud

### SONiC dcloud

For info on launching SONiC VXR with containerlab please refer to https://github.com/brmcdoug/containerlab/tree/main/vxrSONiC

SONiC can be configured one of three ways:
1. /etc/sonic/config_db.json 
   [config_db](/config_guide-config_db.md)
   
2. Linux [CLI](/config_guide-CLI.md)
   - not all features are supported from the Linux CLI
3. FRR [CLI](/config_guide-CLI.md)
   - FRR configs are not persistent across reboots unless you modify /etc/sonic/config_db.json 
>[!NOTE]
>This page needs significant work
