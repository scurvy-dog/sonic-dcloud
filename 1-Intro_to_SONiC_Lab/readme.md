# Welcome to the SONiC on Cisco 8000 Emulator Lab

### Description: This repository contains lab guide, router configs, setup scripts, and other code for running through the lab.

SONiC is an open source network operating system based on Linux that runs on switches/routers from multiple vendors and ASICs. SONiC offers a full-suite of network functionality, like BGP, that has been production-hardened in the data centers of some of the largest cloud-service providers.

Though it is easy to run SONiC in a virtualized lab environment, what this lab brings is the ability to run SONiC on a platform that emulates the Cisco 8000 hardware. That allows for data-plane feature enablement such as QoS, hardware counters, and debug tools. 

The lab software stack is built off the SONiC master build with Cisco specific platform drivers for the Cisco 8000 hardware.

## Contents
* Repository Overview [LINK](#git-repository-overview)
* Lab Topology [LINK](#lab-topology)
* Remote Access [LINK](#remote-access)
* Lab 1 - Launching Topology [LINK](/lab_1/lab_1-guide.md)
* Lab 2 - Explore SONiC OS [LINK](/lab_2/lab_2-guide.md)
* Lab 3 - Global & Interface Configuration [LINK](/lab_3/lab_3-guide.md)
* Lab 4 - ISIS Configuration [LINK](/lab_4/lab_4-guide.md)
* Lab 5 - BGP Configuration [LINK](/lab_5/lab_5-guide.md)
* Lab 6 - QoS Configuration [LINK](/lab_6/lab_6-guide.md)
* Lab 7 - End to End Testing [LINK](/lab_7/lab_7-guide.md)

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

## Lab Topology

This lab is based on a simulated DC fabric design of four SONiC routers running in a docker instance. In addition there are two client VMs named Endpoint-1 and Endpoint-2. Each client system is running the Ubuntu OS.

![Lab Topology](/../topo_drawings/sonic-4-node-topology.png)
