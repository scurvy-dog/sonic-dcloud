# Lab 1 Guide: SONiC Topology Setup and Validation [30 Min]
This dCloud lab makes heavy use of the relatively new Dockerized Cisco 8000 emulator router known. If you wish to explore Cisco 8000 emulator and its uses beyond the scope of this lab the document team has posted an installation guide here: https://www.cisco.com/c/en/us/support/routers/8000-series-virtual-router-emulator/series.html

### Description: 
In Lab 1 the student will launch the SONiC topology and validate it is up and running. This will be the baseline 
topology all subsequent lab exercises. Second, they will validate that the pre-configured ISIS and BGP routing protocols are running and seeing the correct topology. 

## Contents
- [Lab 1 Guide: XRd Topology Setup and Validation \[40 Min\]](#lab-1-guide-xrd-topology-setup-and-validation-30-min)
  - [Lab Objectives](#lab-objectives)
  - [Virtualization Stack](#virtualization-stack)
  - [Validate Device Access](#validate-device-access)
    - [User Credentials](#user-credentials)
    - [Management Network Topology](#management-network-topology)
    - [Validate VM Endpoints](#validate-vm-endpoints)
  - [Launch and Validate SONiC Topology](#launch-and-validate-sonic-topology)
    - [Validate vSONiC State](#validate-vSONiC-state) 
    - [Launch Container Lab Environment](#launch-container-lab-environment)
    - [Connect to Routers](#connect-to-routers)
  - [End of Lab 1](#end-of-lab-1)
  
## Lab Objectives
The student upon completion of Lab 1 should have achieved the following objectives:

* Access to all devices in the lab
* Understand the Cisco 8000 Emulator / SONiC stack
* Understanding of the lab topology and components
* Launch the ContainerLab SONiC topology   

## Virtualization Stack

The software virtualization stack used in this lab consists of several layers. At the base Linux OS level it is possible to run this lab either on bare metal or in a virtualized environment. In our dCloud lab it is running within a hypervisor as a VM. Within the Ubuntu VM named *v-SONiC* we have installed Docker as our container platform. We will user the ContainerLab software to spin up a docker container that runs the Cisco 8000 hardware emulation software and point the emulator to boot the designated SONiC image. We will spin a single heavy container for each SONiC router needed. See the below diagram.

![Software Stack](../topo-drawings/software-stack.png)

## Validate Device Access

Device access for this lab is primarly through SSH. All of the VMs within this toplogy can be accessed once you connect through Cisco AnyConnect VPN to the dCloud environment. Please see the management topology network diagram below. In addition we will launch four instances of SONiC routers running as containers on the VM host "vSONiC". The vSONiC VM acts as a jumpbox for these containerized routers, thus we will SSH into the vSONiC VM and then initiate a separate SSH session to each of the routers. The vSONiC VM is configured for DNS resolution for each router name to save time.

### User Credentials
For the vSONiC VM use the following credentials:
```
User: cisco, Password: C1sco12345
```

For all instances you will use the same user credentials:
```
User: cisco, Password: cisco123
```

### Management Network Topology

![Management Topology](../topo-drawings/management-network-medium.png)

For full size image see [LINK](../topo-drawings/management-network.png)

### Validate VM Endpoints


## Launch and Validate SONiC Topology
### Validate vSONiC State
1. SSH to the Ubuntu VM **vSONiC** where we will launch the XRd routers
    ```
    ssh cisco@198.18.128.100
    ```

2. Change to the Git repository directory and check status
    - The lab repository folder is found in the home directory *`~/sonic-dcloud/`*
    ```
    cd ~/sonic-dcloud/
    ```
    - The repository should automatically update on the lab spin-up. Validate this.
    ```
    git fetch -v
    ```
    ```
    cisco@vsonic:~/sonic-dcloud$ git fetch -v
    From https://github.com/scurvy-dog/sonic-dcloud
    = [up to date]      main       -> origin/main
    ```

3. Validate there are no docker containers running or docker networks for the XRd topology
    ```
    docker ps
    ```
    ```
    cisco@vsonic:~/sonic-dcloud/$ docker ps
    CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
    
    cisco@vsonic:~/sonic-dcloud/$ docker network ls
    NETWORK ID     NAME      DRIVER    SCOPE
    cfd793a3a770   bridge    bridge    local
    b948b6ba5918   host      host      local
    bdf431ee7377   none      null      local
    ```
### Launch Container Lab Environment
1. Change into the lab-1 directory and create the needed linux bridges
   ```
   cd ~/sonic-dcloud/1-Intro_to_SONiC_Lab/lab_1
   sudo ./create-host-bridges.sh
   ```
   Confirm bridges were created succesfully
   ```
   brctl show
   ```
   ```
   cisco@vsonic:~/sonic-dcloud/1-Intro_to_SONiC_Lab/lab_1$ brctl show
   bridge name	bridge id		STP enabled	interfaces
   docker0		8000.0242abf3a8e0	no		
   leaf01e32-host1		8000.000000000000	no		
   leaf02e32-host2		8000.000000000000	no
   ```
    
3. This lab uses a tool called Containerlab to launch the Cisco 8000 emulator and SONiC images for our topology
    ```
    sudo containerlab deploy -t clab-topology.yml
    ```

   Expected Output
   ```
   cisco@vsonic:~/sonic-dcloud/1-Intro_to_SONiC_Lab/lab_1$ sudo containerlab deploy -t clab-topology.yml 
   INFO[0000] Containerlab v0.40.0 started                 
   INFO[0000] Parsing & checking topology file: topology.yml 
   INFO[0000] Creating lab directory: /home/cisco/sonic-dcloud/1-Intro_to_SONiC_Lab/lab_1/clab-c8201-sonic-4-node-clos 
   INFO[0000] Creating docker network: Name="mgt_net", IPv4Subnet="172.10.10.0/24", IPv6Subnet="2001:172:10:10::/80", MTU="1500" 
   INFO[0000] Creating container: "spine01"                
   INFO[0001] Creating container: "spine02"                
   INFO[0002] Creating container: "leaf01"                 
   INFO[0003] Creating container: "leaf02"                 
   INFO[0004] Creating virtual wire: spine01:eth3 <--> leaf02:eth3 
   INFO[0004] Creating virtual wire: leaf02:eth5 <--> leaf02e32-host2:leaf02eth5 
   INFO[0004] Creating virtual wire: spine01:eth1 <--> leaf01:eth1 
   INFO[0004] Creating virtual wire: spine02:eth3 <--> leaf01:eth3 
   INFO[0004] Creating virtual wire: spine01:eth2 <--> leaf01:eth2 
   INFO[0004] Creating virtual wire: spine01:eth4 <--> leaf02:eth4 
   INFO[0004] Creating virtual wire: spine02:eth4 <--> leaf01:eth4 
   INFO[0004] Creating virtual wire: spine02:eth1 <--> leaf02:eth1 
   INFO[0004] Creating virtual wire: spine02:eth2 <--> leaf02:eth2 
   INFO[0004] Creating virtual wire: leaf01:eth5 <--> leaf01e32-host1:leaf01eth5 
   INFO[0006] Adding containerlab host entries to /etc/hosts file 
   INFO[0006] 🎉 New containerlab version 0.43.0 is available! Release notes: https://containerlab.dev/rn/0.43/
   Run 'containerlab version upgrade' to upgrade or go check other installation options at https://containerlab.dev/install/ 
   +---+--------------------------------------+--------------+---------------------+-------+---------+----------------+----------------------+
    | # |                 Name                 | Container ID |        Image        | Kind  |  State  |  IPv4 Address  |     IPv6 Address     |
   +---+--------------------------------------+--------------+---------------------+-------+---------+----------------+----------------------+
   | 1 | clab-c8201-sonic-4-node-clos-leaf01  | f7a45e580658 | c8000-clab-sonic:29 | linux | running | 172.10.10.4/24 | 2001:172:10:10::4/80 |
   | 2 | clab-c8201-sonic-4-node-clos-leaf02  | 5493543b19a6 | c8000-clab-sonic:29 | linux | running | 172.10.10.5/24 | 2001:172:10:10::5/80 |
   | 3 | clab-c8201-sonic-4-node-clos-spine01 | 7d76479d7d84 | c8000-clab-sonic:29 | linux | running | 172.10.10.2/24 | 2001:172:10:10::2/80 |
   | 4 | clab-c8201-sonic-4-node-clos-spine02 | bc2bcb119c92 | c8000-clab-sonic:29 | linux | running | 172.10.10.3/24 | 2001:172:10:10::3/80 |
   +---+--------------------------------------+--------------+---------------------+-------+---------+----------------+----------------------+
   cisco@vsonic:~/sonic-dcloud/1-Intro_to_SONiC_Lab/lab_1$ 
   ```
   
    > **Note**
    > Containerlab command to shutdown the topology:
    ```
    sudo containerlab destroy -t clab-topology.yml
    ```
    
4. Check that the docker containers were created and running
    ```
    docker ps
    ```
    ```
    
 
    ```
7. Confirm the docker networks were created. 
    ```
    docker network ls
    ```
    ```
    cisco@xrd:~/SRv6_dCloud_Lab/lab_1$ docker network ls
    NETWORK ID     NAME                  DRIVER    SCOPE
    cfd793a3a770   bridge                bridge    local
    b948b6ba5918   host                  host      local
    8ff8a898b08c   lab_1_macvlan0        macvlan   local
    62e49899e77a   lab_1_macvlan1        macvlan   local
    f7f3312f9e29   lab_1_mgmt            bridge    local
    2d455a6860aa   lab_1_xrd05-host      bridge    local
    00bae5fdbe48   lab_1_xrd06-host      bridge    local
    bdf431ee7377   none                  null      local
    336a27055564   xrd01-gi1-xrd02-gi0   bridge    local
    da281230d4b3   xrd01-gi2-xrd05-gi0   bridge    local
    a9cdde56cefa   xrd01-gi3             bridge    local
    c254a6c88536   xrd02-gi1-xrd03-gi0   bridge    local
    2fec9b3e52a5   xrd02-gi2-xrd06-gi1   bridge    local
    942edff76963   xrd02-gi3             bridge    local
    7a6f21c0cb6a   xrd03-gi1-xrd04-gi0   bridge    local
    3c6d5ff6828f   xrd03-gi2             bridge    local
    e3eb44320373   xrd03-gi3             bridge    local
    c03ebf10229b   xrd04-gi1-xrd07-gi1   bridge    local
    331c62bb019a   xrd04-gi2-xrd05-gi1   bridge    local
    8a2cb5e8083d   xrd04-gi3             bridge    local
    b300884b2030   xrd05-gi2-xrd06-gi2   bridge    local
    b48429454f4c   xrd06-gi0-xrd07-gi2   bridge    local
    84b7ddd7e018   xrd07-gi3             bridge    local
    ```
Note the docker Network IDs are unique on creation. Docker's network/bridge naming logic is such that the actual Linux bridge instance names are not predictable. Rather than go through some re-naming process the lab setup script calls another small script called 'nets.sh' that resolves the bridge name and writes it to a file that we'll use later for running tcpdump on the virtual links between routers in our topology.

 - The scripts and files reside in the lab 'util' directory:
```
ls ~/SRv6_dCloud_Lab/util/
```
```
cisco@xrd:~/SRv6_dCloud_Lab$ ls ~/SRv6_dCloud_Lab/util/
nets.sh     xrd01-xrd02  xrd02-xrd03  xrd03-xrd04  xrd04-xrd07  xrd06-xrd07
tcpdump.sh  xrd01-xrd05  xrd02-xrd06  xrd04-xrd05  xrd05-xrd06

```
Later we'll use "tcpdump.sh **xrd0x-xrd0y**" to capture packets along the path through the network. 

1. The XRD router instances should be available for SSH access 2 minutes after spin up.

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

### Connect to Routers
1. Starting from the XRD VM log into each router instance 1-7 per the management topology diagram above. Example:
```
ssh cisco@xrd01
```

2. Confirm that the configured interfaces are in an `UP | UP` state
    ```
    RP/0/RP0/CPU0:xrd01#show ip interface brief
    
    Interface                      IP-Address      Status          Protocol Vrf-Name
    Loopback0                      10.0.0.1        Up              Up       default 
    MgmtEth0/RP0/CPU0/0            10.254.254.101  Up              Up       default 
    GigabitEthernet0/0/0/0         10.101.1.2      Up              Up       default 
    GigabitEthernet0/0/0/1         10.1.1.0        Up              Up       default 
    GigabitEthernet0/0/0/2         10.1.1.8        Up              Up       default 
    GigabitEthernet0/0/0/3         unassigned      Shutdown        Down     default
    ```
3. Validate IPv6 connectivity from **xrd01** to **Amsterdam**VM: 
```
ping fc00:0:101:1::1
```

4. SSH to **xrd07** and validate IPv6 connectivity to the **Rome** VM: 
```
ping fc00:0:107:1::1
```

5. Validate adjacencies and traffic passing on each router. Use the topology diagram to determine neighbors. The client devices **Amsterdam** and **Rome** are not running CDP.
    ```
    show cdp neighbors
    ```
    ```
    RP/0/RP0/CPU0:xrd05#show cdp neighbors 
    Wed Dec 21 18:16:57.657 UTC
    Capability Codes: R - Router, T - Trans Bridge, B - Source Route Bridge
                    S - Switch, H - Host, I - IGMP, r - Repeater

    Device ID       Local Intrfce    Holdtme Capability Platform  Port ID
    xrd01           Gi0/0/0/0        121     R          XRd Contr Gi0/0/0/2       
    xrd04           Gi0/0/0/1        179     R          XRd Contr Gi0/0/0/2       
    xrd06           Gi0/0/0/2        124     R          XRd Contr Gi0/0/0/2  
    ```

## End of Lab 1
Please proceed to [Lab 2](https://github.com/scurvy-dog/sonic-dcloud/blob/main/1-Intro_to_SONiC_Lab/lab_2/lab_guide-2.md)
