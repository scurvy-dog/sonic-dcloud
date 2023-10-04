# Welcome to the SONiC on Cisco 8000 Emulator Lab

### Description: This repository contains lab guide, router configs, setup scripts, and other code for this lab.

SONiC is an open source network operating system based on Linux that runs on switches/routers from multiple vendors and ASICs. SONiC offers a full-suite of network functionality, like BGP, that has been production-hardened in the data centers of some of the largest cloud-service providers.

Though it is easy to run SONiC in a virtualized lab environment, what this lab brings is the ability to run SONiC on a platform that emulates the Cisco 8000 hardware. That allows for data-plane feature enablement such as QoS, hardware counters, and debug tools. 

The lab software stack is built off the SONiC master build with Cisco specific platform drivers for the Cisco 8000 hardware.

## Contents
* Repository Overview [LINK](#git-repository-overview)
* Lab Topology [LINK](#lab-topology)
* Remote Access [LINK](#remote-access)
* Exercise 1 - Launching Topology [LINK](lab_exercise_1.md)
* Exercise 2 - Explore SONiC OS [LINK](lab_exercise_2.md)
* Exercise 3 - BGP Configuration [LINK](lab_exercise_3.md)
* Exercise 4 - BFD Configuration [LINK](lab_exercise_4.md)
* Exercise 5 - ACL Configuration [LINK](lab_exercise_5.md)

## Github Repository Overview
Each of the labs is designed to be completed in the order presented. Exercise 1 is the baseline configurations 
needed to build the starting topology and launch the XRd and extended environment.

### Individual  Directories
Within each lab directory you should see several files of importance:


| Directory/File Name      | Description                                                   |
|:-------------------------|:--------------------------------------------------------------|
| ansible                  | Contains all the ansible configurations                       |
| appendix                 | Reference files                                               |
| topo-drawings            | Reference diagram location                                    |
| lab_exercise_X.md        | User guide for each lab                                       |


## Lab Topology

This lab is based on a simulated DC fabric design of four SONiC routers running in a docker instance. In addition there are two client VMs named Endpoint-1 and Endpoint-2. Each client system is running the Ubuntu OS.

![Lab Topology](topo-drawings/sonic-101-topology.png)

## Remote Access


### Device Access Table
| VM Name        | Description                  | Device Type | Access Type |   IP Address    |
|:---------------|:-----------------------------|:-----------:|:-----------:|:---------------:|
| Jumpbox        | File Staging                 | VM          | SSH         | 198.18.128.100  |
| Leaf-1         | C8k Emulator + SONiC routers | VM          | SSH         | 198.18.128.101  |
| Leaf-2         | C8k Emulator + SONiC routers | VM          | SSH         | 198.18.128.102  |
| Spine-1        | C8k Emulator + SONiC routers | VM          | SSH         | 198.18.128.103  |
| Spine-2        | C8k Emulator + SONiC routers | VM          | SSH         | 198.18.128.104  |
| Endpoint-1     | Ubuntu client                | VM          | SSH         | 198.18.128.105  |
| Endpoint-2     | Ubuntu client                | VM          | SSH         | 198.18.128.106  |


* Use Jumpbox VM to access the SONiC routers as follows:

| Device Name    | Device Type | Access Type |   IP Address    |                                           
|:---------------|:------------|:------------|:---------------:|                          
| leaf-1         | router      | SSH         | 172.10.10.101   |
| leaf-2         | router      | SSH         | 172.10.10.102   |
| spine-1        | router      | SSH         | 172.10.10.103   |
| spine-2        | router      | SSH         | 172.10.10.104   |

