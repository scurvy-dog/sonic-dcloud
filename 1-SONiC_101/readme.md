# SONiC-101 Cisco 8000 Emulator Lab

### Description: 

In the SONIC-101 lab we'll review the dCloud hosted topology, get to know the SONiC operating environment, apply interface, IP, and ACL configuration via SONiC's config_db, and setup BGP peering among our 4 fabric members via SONiC's FRR/BGP container.

## Contents
* Repository Overview [LINK](#git-repository-overview)
* Lab Topology [LINK](#lab-topology)
* Remote Access [LINK](#remote-access)
* dCloud Session Overview [LINK](#dcloud-session-overview)
* Exercise 1 - Launching Topology [LINK](lab_exercise_1.md)
* Exercise 2 - Explore SONiC OS [LINK](lab_exercise_2.md)
* Exercise 3 - BGP Configuration [LINK](lab_exercise_3.md)
* Exercise 4 - BFD Configuration [LINK](lab_exercise_4.md)
* Exercise 5 - ACL Configuration [LINK](lab_exercise_5.md)

## Github Repository Overview
Each of the labs is designed to be completed in the order presented. Within each lab directory you should see several files of importance:

| Directory/File Name      | Description                                                   |
|:-------------------------|:--------------------------------------------------------------|
| ansible                  | Contains all the ansible configurations and playbooks         |
| appendix                 | Reference files                                               |
| topo-drawings            | Reference diagram location                                    |
| lab_exercise_X.md        | User guide for each lab exercise                              |


## Lab Topology

This lab is based on a simulated DC fabric design of four dockerized SONiC routers each running inside a Linux host VM. In addition there is the jumpbox VM, from which we'll trigger Ansible playbooks. Finally there are two client VMs named Endpoint-1 and Endpoint-2, from which we'll source test traffic. All VMs are running Ubuntu 22.04.

![Lab Topology](topo-drawings/sonic-101-topology.png)

## Remote Access
We primarily use SSH to interact with all VMs and SONiC routers, however, dCloud does offer SSH through its UI.
*Note*: username and password for all elements in the lab is cisco/cisco123

### Virtual Machine Access Table
| VM Name        | Description                    | Device Type | Access Type |   IP Address    |
|:---------------|:-------------------------------|:-----------:|:-----------:|:---------------:|
| jumpbox        | File Staging, Ansible Playbooks| VM          | SSH         | 198.18.128.100  |
| linux-host-1   | C8k Emulator + SONiC routers   | VM          | SSH         | 198.18.128.101  |
| linux-host-2   | C8k Emulator + SONiC routers   | VM          | SSH         | 198.18.128.102  |
| linux-host-3   | C8k Emulator + SONiC routers   | VM          | SSH         | 198.18.128.103  |
| linux-host-4   | C8k Emulator + SONiC routers   | VM          | SSH         | 198.18.128.104  |
| endpoint-1     | Ubuntu client                  | VM          | SSH         | 198.18.128.105  |
| endpoint-2     | Ubuntu client                  | VM          | SSH         | 198.18.128.106  |


* Once the SONiC routers have completed their deployment (see dCloud Session Overview) they may be access from the Jumpbox VM as follows:

| Device Name       | Device Type | Access Type |   IP Address    |                                           
|:------------------|:------------|:------------|:---------------:|                          
| sonic-rtr-leaf-1  | router      | SSH         | 172.10.10.101   |
| sonic-rtr-leaf-2  | router      | SSH         | 172.10.10.102   |
| sonic-rtr-spine-1 | router      | SSH         | 172.10.10.103   |
| sonic-rtr-spine-2 | router      | SSH         | 172.10.10.104   |

## dCloud Session Overview
When a Cisco dCloud session is launched the scheduler will set a start time at the next quarter-hour mark (top of the hour, 15 after, etc.). Upon reaching the start time dCloud builds out the virtual machine environment, which usually becomes available in just a few minutes.  

In the case of the SONiC 8000 Emulator lab the SONiC routers are not immediately available as they need to go through a VXR build process inside the Linux host VMs. This step is taken care of automatically by an Ansible 'deploy' playbook which is triggered at lab startup. This playbook will launch the dockerized VXR instances that build a SONiC router on each of the Linux host VMs. The SONiC build process takes 10-15 minutes to run and your lab won't truly be ready until it completes. You may monitor the deploy process as the playbook outputs log entries to two logfiles in /home/cisco on the Jumpbox:

deploy.log - summary deployment info
deploy.log.detail - more detailed Ansible output

* Monitor the status of the SONiC router deployments by running 'tail -f' or 'cat' on the logfiles:
```
tail -f deploy.log
tail -f deploy.log.detail
```

Proceed to [lab_exercise_1](lab_exercise_1.md)