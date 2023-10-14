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
When a Cisco dCloud session is launched the scheduler will set a start time at the next quarter-hour mark (top of the hour, 15 after, etc.). Upon reaching the start time dCloud builds out the virtual machine environment and its usually available in just a few minutes.  

In the case of the SONiC 8000 Emulator lab the SONiC routers are not immediately available as they need to go through a VXR build process inside the Linux host VMs. This step is taken care of automatically by an Ansible 'deploy' playbook which is triggered at lab startup. This playbook will launch the dockerized VXR instances that build a SONiC router on each of the Linux host VMs. The SONiC build process takes 10-15 minutes to run and your lab won't truly be ready until it completes. You may monitor the deploy process as the playbook outputs log entries to two logfiles in /home/cisco on the Jumpbox:

deploy.log - summary deployment info
deploy.log.detail - more detailed Ansible output

* Monitor the status of the SONiC router deployments by running 'tail -f' or 'cat' on the logfiles:
```
tail -f deploy.log
tail -f deploy.log.detail
```

Once the  VXR/SONiC build process completes the summary deploy.log file should look something like this:

```
cisco@jumpbox:~$ cat deploy.log
2023-10-14 10:12:34 PDT: Start Container Lab Deploy Script
2023-10-14 10:12:34 PDT: Expect to wait 10+ minutes as containers are built.
2023-10-14 10:12:37 PDT: SONiC Router sonic-rtr-leaf-1 build start 
2023-10-14 10:12:38 PDT: SONiC Router sonic-rtr-spine-2 build start 
2023-10-14 10:12:38 PDT: SONiC Router sonic-rtr-spine-1 build start 
2023-10-14 10:12:37 PDT: SONiC Router sonic-rtr-leaf-2 build start 
2023-10-14 10:12:37 PDT: SONiC Router clab-c8101-sonic-leaf-2 2023-10-14T17:19:13.907514268Z Router up
2023-10-14 10:12:37 PDT: SONiC Router clab-c8101-sonic-leaf-1 2023-10-14T17:18:50.082588335Z Router up
2023-10-14 10:12:38 PDT: SONiC Router clab-c8101-sonic-spine-1 2023-10-14T17:19:47.451838674Z Router up
2023-10-14 10:12:39 PDT: SONiC Router clab-c8101-sonic-spine-2 2023-10-14T17:19:48.751145006Z Router up
2023-10-14 10:27:55 PDT: SONiC Router Health Check Script
2023-10-14 10:27:55 PDT: SONiC Router sonic-rtr-leaf-1: Health Check Passed
2023-10-14 10:27:55 PDT: SONiC Router sonic-rtr-leaf-2: Health Check Passed
2023-10-14 10:27:55 PDT: SONiC Router sonic-rtr-spine-1: Health Check Passed
2023-10-14 10:27:55 PDT: SONiC Router sonic-rtr-spine-2: Health Check Passed
2023-10-14 10:28:06 PDT: sonic-rtr-spine-2 rebuild script complete
```
If all 4 SONiC nodes have come up and passed health check you may proceed to [lab_exercise_1](lab_exercise_1.md)

In some cases a SONiC node fails to successfully build. When this happens the deploy playbook triggers a rebuild process on the failed node. The rebuild will take another 10-12 minutes, so you may begin exercise 1 while also monitoring the rebuilding node in the deploy logs.
