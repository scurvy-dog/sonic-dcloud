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
   sudo ./nets.sh
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
    cisco@vsonic:~/sonic-dcloud/1-Intro_to_SONiC_Lab/lab_1$ docker ps
    CONTAINER ID   IMAGE                 COMMAND                  CREATED              STATUS              PORTS     NAMES
    e482535a8fa3   c8000-clab-sonic:29   "/etc/prepEnv.sh /no…"   About a minute ago   Up About a minute             clab-c8201-sonic-4-node-clos-leaf02
    43646051366d   c8000-clab-sonic:29   "/etc/prepEnv.sh /no…"   About a minute ago   Up About a minute             clab-c8201-sonic-4-node-clos-leaf01
    10b9bda5a913   c8000-clab-sonic:29   "/etc/prepEnv.sh /no…"   About a minute ago   Up About a minute             clab-c8201-sonic-4-node-clos-spine02
    50399c8f057d   c8000-clab-sonic:29   "/etc/prepEnv.sh /no…"   About a minute ago   Up About a minute             clab-c8201-sonic-4-node-clos-spine01
    ```
    
7. Confirm the docker networks were created. 
    ```
    docker network ls
    ```
    ```
    cisco@vsonic:~/sonic-dcloud/1-Intro_to_SONiC_Lab/lab_1$ docker network ls
    NETWORK ID     NAME      DRIVER    SCOPE
    d2b6a7ceece7   bridge    bridge    local
    a2cc09220b8d   host      host      local
    8f3f39b4539f   mgt_net   bridge    local
    31c3f069bdb9   none      null      local
    ```
> **Note**
> the docker Network IDs are unique on creation. Docker's network/bridge naming logic is such that the actual Linux bridge instance names are not predictable. Rather than go through some re-naming process the lab setup script calls another small script called 'nets.sh' that resolves the bridge name and writes it to a file that we'll use later for running tcpdump on the virtual links between routers in our topology.

- The scripts and files reside in the lab 'util' directory:
```
ls ~/sonic-dcloud/1-Intro_to_SONiC_Lab
``` 

8. The SONiC router instances should be available for SSH access 10 minutes after spin up.

### Connect to Routers
1. Starting from the vSONiC VM log into each router instance 1-4 per the management topology diagram above. Example:
    ```
    ssh cisco@172.10.10.2
    ```

2.You can view the default startup configuration for the container. The config_db.json file stores the saved configuration of the container. 
    ```
    cat /etc/sonic/config_db.json | more 
    ```
>**Note**
>Any running configuration changes must be written to the config_db.json to persist in reboots

## End of Lab 1
Please proceed to [Lab 2](https://github.com/scurvy-dog/sonic-dcloud/blob/main/1-Intro_to_SONiC_Lab/lab_2/lab_guide-2.md)
