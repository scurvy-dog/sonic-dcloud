# Lab 2 Guide: SONiC Topology Setup and Validation [40 Min]
This dCloud lab makes heavy use of the relatively new Dockerized Cisco 8000 emulator router known. If you wish to explore Cisco 8000 emulator and its uses beyond the scope of this lab the document team has posted an installation guide here: https://www.cisco.com/c/en/us/support/routers/8000-series-virtual-router-emulator/series.html

### Description: 
In Lab 1 the student will launch the SONiC topology and validate it is up and running. This will be the baseline 
topology all subsequent lab exercises. Second, they will validate that the pre-configured ISIS and BGP routing protocols are running and seeing the correct topology. 

## Contents
  - [Tour of SONiC](#tour-of-sonic)
     - [SONiC Software Architecture](#sonic-software-architecture)
     - [Health Check of SONiC Components](#health-check-of-sonic-components)
     - [Tour of SONiC CLI](#tour-of-sonic-cli)
     - [Managing Configs](#managing-configs)
  - [Ansible Automation](#ansible-automation)
     - [Ansible Playbook Overview](#ansible-playbook-overview)
     - [Review Playboook Results](#review-playbook-results)
  - [Validate Lab Topology](#validate-lab-topology)
  - [End of Lab 2](#end-of-lab-2)
  
## Lab Objectives
The student upon completion of Lab 2 should have achieved the following objectives:

* Understanding of the software components within SONiC
* Ability to see status of various services
* Configuration Management structure
* How to load configuration through Ansible
* Valadiate end toend topology 

## Tour of SONiC
### SONiC Software Architecture
SONiC system's architecture comprises of various modules that interact among each other through a centralized and scalable infrastructure. This infrastructure relies on the use of a redis-database engine: a key-value database to provide a language independent interface, a method for data persistence, replication and multi-process communication among all SONiC subsystems.
    
By relying on the publisher/subscriber messaging paradigm offered by the redis-engine infrastructure, applications can subscribe only to the data-views that they require, and avoid implementation details that are irrelevant to their functionality.

SONiC places each module in independent docker containers to keep high cohesion among semantically-affine components, while reducing coupling between disjointed ones. Each of these components are written to be entirely independent of the platform-specific details required to interact with lower-layer abstractions. See diagram below for high level architecture view.

![Software Architecture](../topo-drawings/sonic-hld-architecture.png)

As of today, SONiC breaks its main functional components into the following docker containers:

| Service Container | Description                                                      |
|:------------------|:-----------------------------------------------------------------|
| BGP               | Runs Quagga or FRR. These stacks include other routing protocols |
| Database          | Hosts the redis-database engine|
| DHCP-Relay        | DHCP-Relay agent |
| LLDP              | Hosts LLDP. Includes 3 process *llpd*, *LLDP-syncd*, *LLDPmgr* |
| MGMT-Framework    | North Bound Interfaces (NBIs) for  managing configuration and status|
| PMON              | Runs *sensord* daemon used to log and alert sensor data |
| RADV              |
| SNMP              | Hosts SNMP feature. *SNMPD* and *SNMP-Agent* |
| SWSS              | Collection of tools to allow communication among all SONiC modules |
| SYNCD             | synchronization of the switch's network state with the switch's actual hardware/ASIC |
| TeamD             | Runs open-source implementation of LAG protocol |

You can see the list of the running containers with SONiC by running the below command once logged into a SONiC device.
```
docker ps
```
```
cisco@spine01:~$ docker ps
CONTAINER ID   IMAGE                                COMMAND                  CREATED        STATUS       NAMES
868157a8bbf5   docker-snmp:latest                   "/usr/local/bin/supe…"   17 hours ago   Up 3 hours   snmp
5644f3c91087   docker-sonic-mgmt-framework:latest   "/usr/local/bin/supe…"   17 hours ago   Up 3 hours   mgmt-framework
099b9115a440   docker-router-advertiser:latest      "/usr/bin/docker-ini…"   17 hours ago   Up 3 hours   radv
878549b44ead   docker-lldp:latest                   "/usr/bin/docker-lld…"   17 hours ago   Up 3 hours   lldp
aa1c44498dee   docker-fpm-frr:latest                "/usr/bin/docker_ini…"   17 hours ago   Up 3 hours   bgp
0a8f12abe9c6   docker-teamd:latest                  "/usr/local/bin/supe…"   17 hours ago   Up 3 hours   teamd
f2996f06bc05   docker-syncd-cisco:latest            "/usr/local/bin/supe…"   17 hours ago   Up 3 hours   syncd
20db7f99de4e   docker-orchagent:latest              "/usr/bin/docker-ini…"   17 hours ago   Up 3 hours   swss
5b7c42be2fbc   docker-platform-monitor:latest       "/usr/bin/docker_ini…"   17 hours ago   Up 3 hours   pmon
199dfb786c07   docker-database:latest               "/usr/local/bin/dock…"   17 hours ago   Up 3 hours   database
```
> **Note**
>For greater detail on container services see this link [HERE](https://github.com/sonic-net/SONiC/wiki/Architecture)

### Health Check of SONiC Components

### Tour of SONiC CLI

### Managing Configurations
Configuration state in SONiC is perserved into several places. For persistant configuratin between reloads configuration files are used. The main configuration is found at */etc/sonic/config_db.json*. The second configuration file in this lab is for the FRR routing stack and it's configuratin is found at */etc/sonic/frr/bgpd.conf*. When the router boots it loads the configuration into these two files into the redis database. The redis database is the running configuration of the router where the various services read or write state information into the redis database.

![redis diagram](../topo-drawings/redis-diagram.png)

### Saving Configuration to a File for Persistence

This command is to save the config DB configuration into the user-specified filename or into the default /etc/sonic/config_db.json. This saves the configuration into the disk which is available even after reboots. Saved file can be transferred to remote machines for debugging. If users wants to load the configuration from this new file at any point of time, they can use "config load" command and provide this newly generated file as input. If users wants this newly generated file to be used during reboot, they need to copy this file to /etc/sonic/config_db.json.

- Usage:
```
config save [-y|--yes] [<filename>]
```
- Example (Save configuration to /etc/sonic/config_db.json):

```
cisco@spine01:~$ sudo config save -y
```

- Example (Save configuration to a specified file):
```
cisco@spine01:~$ sudo config save -y /etc/sonic/config2.json
```
