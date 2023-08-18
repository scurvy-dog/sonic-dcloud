# SONiC Quick Reference Guide for CLI Commands
## Description: 
This page is to help those new to SONiC have a quick reference guide for CLI commands. 

## Contents
- [Global Commands](#global-commands)
- [Configuration Management](#configuration-management)
- [Container Management](#container-management)
- [Reload Commands](#reload-commands)
- [Interface Commands](#interface-commands)
- [Routing Procotols](#routing-protocols)
  - [BGP Commands](#bgp-commands)
  
## Global Commands

###Show Version

Displays the current installed SONiC version as well as Hardware information on the system
```
show version
```

```
SONiC Software Version: SONiC.azure_cisco_202205.5324-dirty-20230707.044127
SONiC OS Version: 11
Distribution: Debian 11.7
Kernel: 5.10.0-18-2-amd64
Build commit: a2dedc96c
Build date: Fri Jul  7 14:22:57 UTC 2023
Built by: sonicci@sonic-ci-7-lnx

Platform: x86_64-8201_32fh_o-r0
HwSKU: 32x400Gb
ASIC: cisco-8000
ASIC Count: 1
Serial Number: FOC2217QGKY
Model Number: 8201-32FH-O
Hardware Revision: 0.33
Uptime: 17:47:47 up 50 min,  1 user,  load average: 0.96, 1.01, 1.03
Date: Fri 18 Aug 2023 17:47:47
```


## Configuration Commands

###Load Configuration**
Load the */etc/sonic/config_db.json* file into the Redis database
```
config load [-y|--yes] [<filename>]
```

###Save Configuration**
Save the current system configuration from the Redis database to the */etc/sonic/config_db.json*
```
config save [-y|--yes] [<filename>]
```

###Reload Configuration**
Clear current configuration and import new configurationn from the input file or from */etc/sonic/config_db.json*
```
config reload [-y|--yes] [-l|--load-sysinfo] [<filename>] [-n|--no-service-restart] [-f|--force]
```


## Container Commands

SONiC uses a docker container system to manage major functional services. As such common docker commands work.
| CLI                              | Notes                                           |
|:---------------------------------|:------------------------------------------------|
| docker images                    | See image build versions for each container     |
| docker logs <container>          | Review the specifics logs of a container        |
| docker ps                        | Lists the subsystem containers running          |
| docker restart <container>       | Restarts a specific container                   |
| docker stats                     | Shows resource consumption by each container    |


## Reload Commands
### Warm Reboot
The goal of SONiC warm reboot is to be able restart and upgrade SONiC software without impacting the data plane. Warm restart of each individual process/docker is also part of the goal. Except for syncd and database docker, it is desired for all other network applications and dockers to support un-planned warm restart.
  - Warm-Reboot must not impact the data plane.

```
sudo warm-reboot
```

### Fast Reboot
Fast-reboot feature enables a switch to reboot up quickly, with minimum disruption to the data plane.
  - Fast-Reboot must disrupt data plane not more than 25 seconds
  - Fast-Reboot must disrupt control plane not more than 90 seconds
  - 
```
sudo fast-reboot
```

## Interface Commands
The student upon completion of Lab 1 should have achieved the following objectives:

* Access to all devices in

## Routing Protocols

### BGP Commands
