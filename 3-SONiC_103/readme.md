# SONiC-103: sonic-vs

### Description: 

The SONIC-103 lab uses a dockerized version of the lightweight sonic-vs image. In this lab we'll launch a small CLOS topology, do some quick review of the SONiC operating environment, configure and validate the topology, and run some test traffic.

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

This lab is based on a simulated DC fabric design of six dockerized sonic-vs nodes. The Cisco dCloud topology itself resides inside an Ubuntu host VM, however the lab can be easily recreated in other environments or in the cloud. 

![Lab Topology](topo-drawings/sonic-103-topology.png)

## Remote Access
We primarily use SSH to interact with all VMs and SONiC routers, however, dCloud does offer SSH through its UI.
*Note*: username and password for all elements in the lab is:

```
cisco/cisco123
```

### Virtual Machine Access Table
| VM Name        | Description                    | Device Type | Access Type |   IP Address    |
|:---------------|:-------------------------------|:-----------:|:-----------:|:---------------:|
| linux-host-1   | C8k Emulator / SONiC routers   | VM          | SSH         | 198.18.128.101  |
| endpoint-1     | Ubuntu client                  | VM          | SSH         | 198.18.128.105  |
| endpoint-2     | Ubuntu client                  | VM          | SSH         | 198.18.128.106  |


* Once the SONiC routers have completed their deployment (see [LINK](#dcloud-session-overview)) they may be accessed from the Linux Host VM as follows:

1. Use Anyconnect client and your dCloud credentials to establish a VPN session
2. ssh to the Linux host VM: ssh cisco@198.18.128.101
3. From the Linux host ssh to each SONiC node per this table:

| Device Name       | Device Type | Access Type |   IP Address    |                                           
|:------------------|:------------|:------------|:---------------:|                          
| sonic-rtr-leaf-1  | router      | SSH         | 192.168.122.101   |
| sonic-rtr-leaf-2  | router      | SSH         | 192.168.122.102   |
| sonic-rtr-spine-1 | router      | SSH         | 192.168.122.103   |
| sonic-rtr-spine-2 | router      | SSH         | 192.168.122.104   |

## dCloud Session Overview
When a Cisco dCloud session is launched the scheduler will set a start time at the next quarter-hour mark (top of the hour, 15 after, etc.). Upon reaching the start time dCloud builds out the virtual machine environment, which usually becomes available in just a few minutes.  

In the case of the SONiC 8000 Emulator lab the SONiC routers are not immediately available as they need to go through a VXR build process inside the Linux host VMs. This step is taken care of automatically by an Ansible 'deploy' playbook which is triggered at lab startup. This playbook will launch the four router VMs and trigger the SONiC build process. The build process takes 10-15 minutes to run and your lab won't truly be ready until it completes. You may monitor the deploy/build process as the playbook outputs log entries to the deploy.log file /home/cisco on the Linux host VM.

* Monitor the status of the SONiC router deployments by running 'tail -f' or 'cat' on the logfile:
```
tail -f deploy.log
```

Proceed to [lab_exercise_1](lab_exercise_1.md)
