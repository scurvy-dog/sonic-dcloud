### Notes for SONiC 101 Lab Exercise 1 - Launching the 4-node topology with Containerlab

A 4-node topology using the Cisco 8000 hardware emulator VM and running SONiC network operating system

To launch the sonic 101 topology on your dCloud VM:

1. VPN into dCloud then ssh to the host VM
```
ssh cisco@198.18.128.100
pw = C1sco12345
```

2. cd into sonic-dcloud/1-Intro_to_SONiC_Lab directory
```
cd sonic-dcloud/1-Intro_to_SONiC_Lab
```

3. run the containerlab deploy command to deploy the topology:
```
sudo containerlab deploy -t topology.yml
```
 - Expected output:
    ```
    cisco@vsonic:~/sonic-dcloud/1-Intro_to_SONiC_Lab$ sudo containerlab deploy -t topology.yml 
    INFO[0000] Containerlab v0.40.0 started                 
    INFO[0000] Parsing & checking topology file: topology.yml 
    INFO[0000] Creating lab directory: /home/cisco/sonic-dcloud/1-Intro_to_SONiC_Lab/clab-c8201-sonic-4-node-clos 
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
    cisco@vsonic:~/sonic-dcloud/1-Intro_to_SONiC_Lab$ 
    ```
Note - containerlab command to take the topology down:
```
sudo containerlab destroy -t topology.yml 
```

4. The sonic/8000 nodes will take 10-12 minutes to launch. Check docker logs to monitor their progress:
```
docker logs -f clab-c8201-sonic-4-node-clos-leaf01 
```
 - Example (truncated) output:
    ```
    cisco@vsonic:~$ docker logs -f clab-c8201-sonic-4-node-clos-leaf01 
    mknod: /dev/net/tun: File exists
    net.ipv6.conf.all.disable_ipv6 = 0
    * Starting OpenBSD Secure Shell server sshd                             [ OK ] 
    Invoking /nobackup/startup.py 8000.yaml 4
    ['/nobackup/startup.py', '8000.yaml', '4']
    20:24:05 INFO R0:waiting for SONIC login prompt after 'onie-nos-install sonic-cisco-8000-clab.bin' (console output captured in vxr.out/logs/console.R0.log)
    20:28:58 INFO R0:got login prompt. Attempting to re-login.
    20:28:58 INFO R0:onie sonic login cisco/cisco123
    20:28:58 INFO R0:entering sonic username 'cisco'
    20:28:59 INFO R0:entering sonic password 'cisco123'
    20:28:59 INFO R0:reached sonic prompt
    20:28:59 INFO R0:reached sonic prompt
    20:28:59 INFO R0:login successful
    20:28:59 INFO R0:wait for swss to enter active state
    20:29:19 INFO R0:swss in active state
    20:29:19 INFO R0:wait for SONIC interfaces to get created
    20:29:19 INFO R0:onie sonic login cisco/cisco123
    20:29:19 INFO R0:reached sonic prompt
    20:29:19 INFO R0:checking interfaces
    20:29:23 INFO R0:found 0 interfaces (expected 32)
    20:29:54 INFO R0:found 0 interfaces (expected 32)
    20:32:34 INFO R0:found 32 interfaces (expected 32)
    20:32:34 INFO R0:applying XR config
    20:32:44 INFO Sim up
    Router up
    ^C
    cisco@vsonic:~$ 
    ```

### Occasionally a router won't fully boot due to docker timeout issues
The docker log will show the following error message:
```
Exception: R0:Timeout waiting for '--More-- OR @sonic:~\$' after 'show interfaces status' command. !!! FOR CLUES, CHECK vxr.out/logs/console.R0.log !!!
Router failed to come up

<snip>

==================== SUMMARY =====================
No problems found....
=================== SUMMARY END ==================
```
### Workaround:

1. exec into the container and manually run the startup.py script specifying the 8000.yaml file and interface count (Leaf nodes have 5 interfaces, Spine nodes have 4):
```
docker exec -it clab-c8201-sonic-4-node-clos-leaf01 bash
cd nobackup
./startup.py 8000.yaml 5
```
Example:
```
cisco@vsonic:~$ docker exec -it clab-c8201-sonic-4-node-clos-leaf01 bash
root@leaf01:/# cd nobackup/
root@leaf01:/nobackup# ls
8000.yaml  eth0.config  hosts  ovs  pyvxr.log  root  startup.err  startup.log  startup.py  startup.sh  startup.wrap.sh  startup.yaml  vxr.out
root@leaf01:/nobackup# ./startup.py 8000.yaml 5
['./startup.py', '8000.yaml', '5']
MGMT_IP: 172.10.10.4  MASK: 255.255.255.0  GATEWAY: 172.10.10.1
Found 5 data interfaces (expected 5)

<snip>

15:42:00 INFO R0:waiting for SONIC login prompt after 'onie-nos-install sonic-cisco-8000-clab.bin' (console output captured in vxr.out/logs/console.R0.log)

```
### Accessing routers and get familiar with SONiC CLI

1. Once the routers are up you can ssh to them and explore the Linux/Debian environment and SONiC CLI. Notice how they currently all have the same hostname. We'll change that and other parameters in step 7.
```
ssh cisco@172.10.10.2
ssh cisco@172.10.10.3
ssh cisco@172.10.10.4
ssh cisco@172.10.10.5
pw = cisco123
```

2. Run some SONiC CLI commands:
```
show ?
show runningconfiguration all
show interfaces status
show ip interfaces
show ipv6 interfaces
```
   
3. We'll use an Ansible playbook to apply global configurations to our nodes. cd into the ansible directory and run the lab-1-configs.yml playbook. This playbook will perform the following on each router:
   * Backup the existing /etc/sonic/config_db.json file
   * Copy the appropriate config_db.json file from this repo to the router
   * Reload the SONiC config
```
ansible-playbook -i hosts lab-1-configs.yml -e "ansible_user=cisco ansible_ssh_pass=cisco123 ansible_sudo_pass=cisco123" -vv
```
  - The tail end of the output should look something like:
    ```
    PLAY RECAP 
PLAY RECAP **********************************************************************************************************************************************************************************************
leaf01      : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
leaf02      : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
spine01     : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
spine02     : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
    ```
4. Next ssh into the routers (notice the hostname change) 
```
ssh cisco@172.10.10.2
vtysh
```

5. The routers' interfaces won't be immediately available after config reload. Wait for interfaces to come up before proceeding to the next step. Use any of the following to verify interfaces:

```
show ip interfaces
show ipv6 interfaces
show interfaces status
```

Example output:
```
cisco@spine02:~$ show ipv6 interfaces 
Interface     Master        IPv6 address/mask                          Admin/Oper    BGP Neighbor    Neighbor IP
------------  ------------  -----------------------------------------  ------------  --------------  -------------
Bridge                      fe80::e8b7:96ff:fef7:8f32%Bridge/64        up/down       N/A             N/A
Ethernet0     PortChannel1  fe80::7aeb:5aff:fe63:f002%Ethernet0/64     up/up         N/A             N/A
Ethernet8     PortChannel1  fe80::7aeb:5aff:fe63:f002%Ethernet8/64     up/up         N/A             N/A
Ethernet16    PortChannel2  fe80::7aeb:5aff:fe63:f002%Ethernet16/64    up/up         N/A             N/A
Ethernet24    PortChannel2  fe80::7aeb:5aff:fe63:f002%Ethernet24/64    up/up         N/A             N/A
Ethernet32                  fe80::7aeb:5aff:fe63:f002%Ethernet32/64    up/up         N/A             N/A
```

6. Verify port channels are in an up/up state

```
show interfaces portchannel
```

Example output:
```
cisco@spine02:~$ show interfaces portchannel 
Flags: A - active, I - inactive, Up - up, Dw - Down, N/A - not available,
       S - selected, D - deselected, * - not synced
  No.  Team Dev      Protocol     Ports
-----  ------------  -----------  ---------------------------
    1  PortChannel1  LACP(A)(Up)  Ethernet0(S) Ethernet8(S)
    2  PortChannel2  LACP(A)(Up)  Ethernet24(S) Ethernet16(S)
```

7. Run some pings:

```
cisco@spine01:~$ show ip int
Interface     Master    IPv4 address/mask    Admin/Oper    BGP Neighbor    Neighbor IP
------------  --------  -------------------  ------------  --------------  -------------
Loopback0               10.0.0.1/32          up/up         N/A             N/A
PortChannel1            10.1.1.1/31          up/down       N/A             N/A
PortChannel2            10.1.1.5/31          up/down       N/A             N/A
docker0                 240.127.1.1/24       up/down       N/A             N/A
eth0                    172.10.10.2/24       up/up         N/A             N/A
eth4                    192.168.123.182/24   up/up         N/A             N/A
lo                      127.0.0.1/16         up/up         N/A             N/A

cisco@spine01:~$ ping 10.1.1.0
PING 10.1.1.0 (10.1.1.0) 56(84) bytes of data.
64 bytes from 10.1.1.0: icmp_seq=1 ttl=64 time=414 ms
64 bytes from 10.1.1.0: icmp_seq=2 ttl=64 time=227 ms

cisco@spine01:~$ ping 10.1.1.4
PING 10.1.1.4 (10.1.1.4) 56(84) bytes of data.
64 bytes from 10.1.1.4: icmp_seq=1 ttl=64 time=221 ms
64 bytes from 10.1.1.4: icmp_seq=2 ttl=64 time=494 ms
```

8. Invoke the FRR CLI. Its a whole lot like IOS:
```
show run
conf t
show interface brief 
```

Proceed to Lab 2 - FRR ISIS and BGP configuration

