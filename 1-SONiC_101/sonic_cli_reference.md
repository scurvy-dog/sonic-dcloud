# SONiC Quick Reference Guide for CLI Commands
## Description: 
This page is to help those new to SONiC have a quick reference guide for CLI commands. 

## Contents
- [SONiC Quick Reference Guide for CLI Commands](#sonic-quick-reference-guide-for-cli-commands)
  - [Description:](#description)
  - [Contents](#contents)
  - [Global Commands](#global-commands)
    - [Show Version](#show-version)
    - [Show Boot Information](#show-boot-information)
    - [Other global commands](#other-global-commands)
    - [System Logs](#system-logs)
  - [Configuration Commands](#configuration-commands)
  - [Container Commands](#container-commands)
  - [Reload Commands](#reload-commands)
    - [Warm Reboot](#warm-reboot)
    - [Fast Reboot](#fast-reboot)
  - [Interface 'show' Commands](#interface-show-commands)
  - [Vlans and Layer 2](#vlans-and-layer-2)
    - [VLAN](#vlan)
  - [Routing Protocols and Layer 3](#routing-protocols-and-layer-3)
    - [IPv4 Routing](#ipv4-routing)
    - [VRF Commands](#vrf-commands)
    - [BGP Commands](#bgp-commands)
    - [FRR](#frr)
  
## Global Commands

### Show Version

Displays the current installed SONiC version as well as Hardware information on the system
```
show version
```

Example output:
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

### Show Boot Information
Display current and next boot partition information:

```
show boot
```

### Other global commands
```
show processes [cpu | memory | summary]
show system memory
show services
show platform summary
show platform pcieinfo
show runningconfiguration
crm show resources all
```

### System Logs
View system logs:

```
sudo tail /var/log/syslog
```

## Configuration Commands

###Load Configuration
Load the */etc/sonic/config_db.json* file into the Redis database
```
config load [-y|--yes] [<filename>]
```

###Save Configuration
Save the current system configuration from the Redis database to the */etc/sonic/config_db.json*
```
config save [-y|--yes] [<filename>]
```

###Reload Configuration
Clear current configuration and import new configurationn from the input file or from */etc/sonic/config_db.json*
```
config reload [-y|--yes] [-l|--load-sysinfo] [<filename>] [-n|--no-service-restart] [-f|--force]
```

####View Configuration
Display current configuration:

```
show runningconfiguration all
cat /etc/sonic/config_db.json
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
    
```
sudo fast-reboot
```

## Interface 'show' Commands

Show interface status in an abbreviated format
```
show interfaces description
```

Show interface status in more detail
```
show interfaces status
```

Show lldp neighbor adjacency 
```
show lldp table
```

Show portchannel
```
sudo config portchannel add PortChannel1
```

Show interfaces status

```
show interfaces status
show interfaces status Ethernet8
```

Show ip interfaces: Interfaces, Assigned VRF, IPv4 Address, Administrative and operational state, BGP neighbor, Neighbor IP

```
show ip interfaces
```

Check traffic and counters for an interface

```
show interfaces counters -i Ethernet0
show interfaces counters detailed  Ethernet0
```

Display the running configuration for an interface:

```
show runningconfiguration interfaces
```

Show transceiver for an interface.

```
show interfaces transceiver  status Ethernet0
show interfaces transceiver  eeprom  Ethernet0
show interfaces transceiver info Ethernet0
```

## Vlans and Layer 2

### VLAN

Adding a VLAN 

```
sudo config vlan add 20
```

Assign an interface to a VLAN

```
sudo config vlan member add -u 20 Ethernet0
```

## Routing Protocols and Layer 3

### IPv4 Routing

Assign an IPv4 address to an interface:

```
sudo config interface ip add Ethernet8 100.0.14.22/24
```

Assign an IPv4 address to a VLAN Interface:

```
sudo config interface ip add Vlan20 21.21.21.1/24
```


Remove an IPv4 address from an interface

```
sudo config interface ip remove Ethernet8 100.0.14.22/24
```


Show the ipv4 routing table:

```
show ip route or ip route show
```

### VRF Commands

```
show vrf
```


### BGP Commands

Show BGP configuration
```
show runningconfiguration bgp
```

### FRR

FRR integrates into SONiC as the core routing protocol stack, offering dynamic routing capabilities such as BGP, OSPF, and IS-IS. This integration allows SONiC to handle complex routing scenarios and enables seamless communication between network devices. By leveraging FRR, SONiC combines the agility of a modern NOS with the reliability and scalability of proven routing protocols, making it a powerful solution for building scalable and efficient network infrastructures.

Accessing the FRR Stack

```
vtysh
'''

Show configuration 

```
show run
```
