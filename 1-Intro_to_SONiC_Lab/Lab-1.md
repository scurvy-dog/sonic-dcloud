### SONiC 101 Lab Exercise 1 - Launching the 4-node topology with Containerlab

A 4-node topology using the Cisco 8000 hardware emulator VM and running SONiC network operating system

To launch the sonic 101 topology on your dCloud VM:

1. VPN into dCloud then ssh to the host VM
```
ssh cisco@198.18.128.100
pw = C1sco12345
```

2. cd into sonic-dcloud/sonic101 directory
```
cd sonic-dcloud/sonic101/
```

3. run the containerlab deploy command to deploy the topology:
```
sudo containerlab deploy -t 4-node-clos.yml 
```
 - Expected output:
    ```
    cisco@vsonic:~/sonic-dcloud/sonic101$ sudo containerlab deploy -t 4-node-clos.yml 
    INFO[0000] Containerlab v0.40.0 started                 
    INFO[0000] Parsing & checking topology file: 4-node-clos.yml 
    INFO[0000] Creating lab directory: /home/cisco/sonic-dcloud/sonic101/clab-c8201-sonic-4-node-clos 
    INFO[0000] Creating docker network: Name="fixedips", IPv4Subnet="172.10.10.0/24", IPv6Subnet="2001:172:20:5::/80", MTU="1500" 
    INFO[0000] Creating container: "r1"                     
    INFO[0001] Creating container: "r2"                     
    INFO[0002] Creating container: "r3"                     
    INFO[0003] Creating container: "r4"                     
    INFO[0004] Creating virtual wire: r2:eth4 <--> r2e24-r4e24:r2eth4 
    INFO[0004] Creating virtual wire: r1:eth5 <--> r1e32-host1:r1eth5 
    INFO[0004] Creating virtual wire: r2:eth5 <--> r2e32-host3:r2eth5 
    INFO[0004] Creating virtual wire: r2:eth1 <--> r2e0-r3e16:r2eth1 
    INFO[0004] Creating virtual wire: r2:eth3 <--> r2e16-r4e16:r2eth3 
    INFO[0004] Creating virtual wire: r2:eth2 <--> r2e8-r3e24:r2eth2 
    INFO[0004] Creating virtual wire: r1:eth2 <--> r1e8-r3e8:r1eth2 
    INFO[0004] Creating virtual wire: r4:eth3 <--> r2e16-r4e16:r4eth3 
    INFO[0004] Creating virtual wire: r3:eth2 <--> r1e8-r3e8:r3eth2 
    INFO[0004] Creating virtual wire: r1:eth6 <--> r1e40-host2:r1eth6 
    INFO[0004] Creating virtual wire: r4:eth1 <--> r1e16-r4e0:r4eth1 
    INFO[0004] Creating virtual wire: r4:eth2 <--> r1e24-r4e8:r4eth2 
    INFO[0004] Creating virtual wire: r4:eth4 <--> r2e24-r4e24:r4eth4 
    INFO[0004] Creating virtual wire: r3:eth4 <--> r2e8-r3e24:r3eth4 
    INFO[0004] Creating virtual wire: r1:eth3 <--> r1e16-r4e0:r1eth3 
    INFO[0004] Creating virtual wire: r3:eth3 <--> r2e0-r3e16:r3eth3 
    INFO[0004] Creating virtual wire: r1:eth4 <--> r1e24-r4e8:r1eth4 
    INFO[0004] Creating virtual wire: r2:eth6 <--> r2e40-host4:r2eth6 
    INFO[0004] Creating virtual wire: r1:eth1 <--> r1e0-r3e0:r1eth1 
    INFO[0004] Creating virtual wire: r3:eth1 <--> r1e0-r3e0:r3eth1 
    ERRO[0010] failed to run postdeploy task for node r1e40-host2: failed to add iptables forwarding rule for bridge "r1e40-host2": exit status 4 
    ERRO[0010] failed to run postdeploy task for node r2e16-r4e16: failed to add iptables forwarding rule for bridge "r2e16-r4e16": exit status 4 
    INFO[0010] Adding containerlab host entries to /etc/hosts file 
    INFO[0010] 🎉 New containerlab version 0.43.0 is available! Release notes: https://containerlab.dev/rn/0.43/
    Run 'containerlab version upgrade' to upgrade or go check other installation options at https://containerlab.dev/install/ 
    +---+---------------------------------+--------------+---------------------+-------+---------+----------------+----------------------+
    | # |              Name               | Container ID |        Image        | Kind  |  State  |  IPv4 Address  |     IPv6 Address     |
    +---+---------------------------------+--------------+---------------------+-------+---------+----------------+----------------------+
    | 1 | clab-c8201-sonic-4-node-clos-r1 | c35360ed9332 | c8000-clab-sonic:27 | linux | running | 172.10.10.11/24 | 2001:172:20:5::11/80 |
    | 2 | clab-c8201-sonic-4-node-clos-r2 | 4d45d6059ca7 | c8000-clab-sonic:27 | linux | running | 172.10.10.12/24 | 2001:172:20:5::12/80 |
    | 3 | clab-c8201-sonic-4-node-clos-r3 | 84eb037ce35b | c8000-clab-sonic:27 | linux | running | 172.10.10.13/24 | 2001:172:20:5::13/80 |
    | 4 | clab-c8201-sonic-4-node-clos-r4 | 620da68ec011 | c8000-clab-sonic:27 | linux | running | 172.10.10.14/24 | 2001:172:20:5::14/80 |
    +---+---------------------------------+--------------+---------------------+-------+---------+----------------+----------------------+
    cisco@vsonic:~/sonic-dcloud/sonic101$
    ```

4. The sonic/8000 nodes will take 10-12 minutes to launch. Check docker logs to monitor their progress:
```
docker logs -f clab-c8201-sonic-4-node-clos-r3
```
 - Example (truncated) output:
    ```
    cisco@vsonic:~$ docker logs -f clab-c8201-sonic-4-node-clos-r3
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
5. Once the routers are up you can ssh to them and explore the Linux/Debian environment and SONiC CLI. Notice how they currently all have the same hostname. We'll change that and other parameters in step 7.
```
ssh cisco@172.10.10.11
ssh cisco@172.10.10.12
ssh cisco@172.10.10.13
ssh cisco@172.10.10.14
pw = cisco123
```

6. Run some SONiC CLI commands:
```
show ?
show runningconfiguration all
show interfaces status
show ip interfaces
show ipv6 interfaces
```
   
7. We'll use an Ansible playbook to apply global configurations to our nodes. cd into the ansible directory and run the sonic101 day-0 playbook. This playbook will perform the following on each router:
   * Backup the existing /etc/sonic/config_db.json file
   * Copy the appropriate config_db.json file from this repo to the router
   * Reload the SONiC config
```
ansible-playbook -i hosts sonic101-4-node-day-0.yml -e "ansible_user=cisco ansible_ssh_pass=cisco123 ansible_sudo_pass=cisco123" -vv
```
  - The tail end of the output should look something like:
    ```
    PLAY RECAP ***************************************************************************************************
    sonic01: ok=5   changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    sonic02: ok=5   changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    sonic03: ok=5   changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    sonic04: ok=5   changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    ```
8. Next ssh into the routers (notice the hostname change) and invoke the FRR CLI
```
ssh cisco@172.10.10.11
vtysh
```

9. Its a whole lot like IOS:
```
show run
conf t
show interface brief 
```

Proceed to Lab 2 - FRR BGP configuration

