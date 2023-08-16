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


## Validate Lab Topology
### Validate Client VMs

__Endpoint-1__

In our lab the Rome VM represents a standard linux host or endpoint, and is essentially a customer/user of our network.

1. SSH to Endpoint-1 Client VM from your laptop.
   ```
   ssh cisco@198.18.128.103
   ```

2. Check that the interface to router leaf01 is `UP` and has the assigned IP `10.107.1.1/24`
   ```
   cisco@endpoint-1:~$ ip address show ens192
    3: ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
        link/ether 00:50:56:aa:ab:cf brd ff:ff:ff:ff:ff:ff
        inet <strong>10.107.1.1/24</strong> brd 10.107.1.255 scope global ens192  <------- Here
        valid_lft forever preferred_lft forever
        inet6 fc00:0:107:1:250:56ff:feaa:abcf/64 scope global dynamic mngtmpaddr noprefixroute 
        valid_lft 2591929sec preferred_lft 604729sec
        inet6 fc00:0:107:1::1/64 scope global 
        valid_lft forever preferred_lft forever
        inet6 fe80::250:56ff:feaa:abcf/64 scope link 
        valid_lft forever preferred_lft forever
   ```
3. Check connectivity from Endpoint-1 to leaf01
   ```
   cisco@rome:~$ ping -c 3 10.107.1.2
   PING 10.107.1.2 (10.107.1.2) 56(84) bytes of data.
   64 bytes from 10.107.1.2: icmp_seq=1 ttl=255 time=2.70 ms
   64 bytes from 10.107.1.2: icmp_seq=2 ttl=255 time=1.38 ms
   64 bytes from 10.107.1.2: icmp_seq=3 ttl=255 time=1.30 ms
   ```

__Endpoint-2__

The Endpiont-2 VM represents a VM belonging in another virtual network (different then Endpoint-1 VM). The Endpoint-1 VM comes with VPP pre-installed. VPP (also known as https://fd.io/) is a very flexible and high performance open source software dataplane. 

1. SSH to Endpoint-2 Client VM from your laptop.
   ```
   ssh cisco@198.18.128.102
   ```

2. Check that the VPP interface facing Ubuntu (host-vpp-in) and the interface facing router xrd01 (GigabitEthernetb/0/0) are `UP` and have their assigned IP addresses. GigabitEthernetb/0/0: `10.101.1.1/24`, and host-vpp-in: `10.101.2.2/24` 
    
    ```
    sudo vppctl show interface address
    ```
    ```
    cisco@amsterdam:~$ sudo vppctl show interface address
    GigabitEthernetb/0/0 (up):
    L3 10.101.1.1/24        <-------HERE
    L3 fc00:0:101:1::1/64
    host-vpp-in (up):
    L3 10.101.2.2/24        <-------HERE
    ```
    
3. Check connectivity from Endpoint-2 to leaf02 - we'll issue a ping from VPP itself:
    ```
    sudo vppctl ping 10.101.1.2
    ```

    ```
    cisco@amsterdam:~$ sudo vppctl ping 10.101.1.2
    116 bytes from 10.101.1.2: icmp_seq=1 ttl=255 time=2.7229 ms
    116 bytes from 10.101.1.2: icmp_seq=2 ttl=255 time=1.1550 ms
    116 bytes from 10.101.1.2: icmp_seq=3 ttl=255 time=1.1341 ms
    116 bytes from 10.101.1.2: icmp_seq=4 ttl=255 time=1.2277 ms
    116 bytes from 10.101.1.2: icmp_seq=5 ttl=255 time=.8838 ms

    Statistics: 5 sent, 5 received, 0% packet loss
    cisco@amsterdam:~$ 
    ```

Device access 
