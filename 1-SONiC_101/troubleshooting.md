# Troubleshooting the lab

## Contents
- [Troubleshooting the lab](#troubleshooting-the-lab)
  - [Contents](#contents)
  - [Typical Issues](#typical-issues)
    - [No Data Interfaces](#no-data-interfaces)
    - [Manual VXR Rebuild](#manual-vxr-rebuild)
    - [Can't Ping SONiC Managment Interface](#cant-ping-sonic-managment-interface)
  
## Typical Issues
The most common scenarioes where trouble may happen with the SONiC nodes are:

1. SONiC node fails to populate interfaces from the Cisco 8000 Emulator - [No Data Interfaces](#no-data-interfaces)
2. SONiC node fails to get a management IP - [Can't Ping SONiC Managment Interface](#cant-ping-sonic-managment-interface)

### No Data Interfaces

1. Example output; no "Ethernet" intefaces are displayed
```
cisco@sonic:~$ show interfaces status
  Interface    Lanes    Speed    MTU    FEC    Alias    Vlan    Oper    Admin    Type    Asym PFC
-----------  -------  -------  -----  -----  -------  ------  ------  -------  ------  ----------
cisco@sonic:~$ 
```

2. Check status of SONiC's docker containers:
```
cisco@sonic:~$ docker ps
CONTAINER ID   IMAGE                                COMMAND                  CREATED        STATUS       PORTS     NAMES
a6c59ed693d6   docker-sonic-mgmt-framework:latest   "/usr/local/bin/supe…"   10 hours ago   Up 3 hours             mgmt-framework
7938168399b6   docker-sonic-telemetry:latest        "/usr/local/bin/supe…"   10 hours ago   Up 3 hours             telemetry
9b611de2c1ac   docker-lldp:latest                   "/usr/bin/docker-lld…"   10 hours ago   Up 3 hours             lldp
887b506094b7   docker-platform-monitor:latest       "/usr/bin/docker_ini…"   10 hours ago   Up 3 hours             pmon
1c38d40bdb33   docker-database:latest               "/usr/local/bin/dock…"   10 hours ago   Up 3 hours             database
```

3. In this case the *'swss'* container is not active. Try restarting the container:
```
docker start swss
```
Example:
```
cisco@sonic:~$ docker start swss
swss
cisco@sonic:~$ docker ps
CONTAINER ID   IMAGE                                COMMAND                  CREATED        STATUS          PORTS     NAMES
a6c59ed693d6   docker-sonic-mgmt-framework:latest   "/usr/local/bin/supe…"   10 hours ago   Up 3 hours                mgmt-framework
7938168399b6   docker-sonic-telemetry:latest        "/usr/local/bin/supe…"   10 hours ago   Up 3 hours                telemetry
05f9a8380cad   docker-snmp:latest                   "/usr/local/bin/supe…"   10 hours ago   Up 42 seconds             snmp
03be98ae797e   62d64691b107                         "/usr/bin/docker_ini…"   10 hours ago   Up 40 seconds             dhcp_relay
9b611de2c1ac   docker-lldp:latest                   "/usr/bin/docker-lld…"   10 hours ago   Up 3 hours                lldp
887b506094b7   docker-platform-monitor:latest       "/usr/bin/docker_ini…"   10 hours ago   Up 3 hours                pmon
ff42b91a47cf   docker-fpm-frr:latest                "/usr/bin/docker_ini…"   10 hours ago   Up 41 seconds             bgp
7747060faaa0   docker-router-advertiser:latest      "/usr/bin/docker-ini…"   10 hours ago   Up 42 seconds             radv
e118cf749a98   docker-syncd-cisco:latest            "/usr/local/bin/supe…"   10 hours ago   Up 43 seconds             syncd
8019b3338129   docker-teamd:latest                  "/usr/local/bin/supe…"   10 hours ago   Up 39 seconds             teamd
2b93ee7532ba   docker-orchagent:latest              "/usr/bin/docker-ini…"   10 hours ago   Up 44 seconds             swss
1c38d40bdb33   docker-database:latest               "/usr/local/bin/dock…"   10 hours ago   Up 3 hours                database
cisco@sonic:~$ 
```

4. If the Ethernet interfaces are still not displaying after 3-4 minutes, please trigger a [Manual VXR Rebuild](#manual-vxr-rebuild)

### Manual VXR Rebuild
Time to destroy and re-deploy the topology:

1. cd into the ansible directory and run the 'destroy' playbook:
```
cd ~/sonic-dcloud/1-SONiC_101/ansible

ansible-playbook -i hosts lab_destroy-playbook.yml -e "ansible_user=cisco ansible_ssh_pass=cisco123 ansible_sudo_pass=cisco123" -vv
```
2. After the destroy playbook completes run the 'deploy' playbook:
```
ansible-playbook -i hosts lab_deploy-playbook.yml -e "ansible_user=cisco ansible_ssh_pass=cisco123 ansible_sudo_pass=cisco123" -vv
```
The deployment will take another ~10 minutes, please follow the same process of monitoring logs, etc.


### Can't Ping SONiC Managment Interface 
By default the SONiC nodes' mgt interfaces get a DHCP address to begin with. We've then re-assigned them as static IPs. However, on occasion the re-assignment will fail and thus the ping test will fail. To address this we'll console into the node and re-assign its mgt IP.

1. Each node's console port can be found in its "Portvector.txt" file which can be found in the vxr-out/*node-name*/ directory. In this example we'll 'cat' leaf-1's Portvector.txt file:
```
cat ~/sonic-dcloud/1-SONiC_101/vxr/vxr.out/leaf-1/PortVector.txt 
```
Output:
```
cisco@linux-host-1:~$ cat sonic-dcloud/1-SONiC_101/vxr/vxr.out/leaf-1/PortVector.txt 
HostAgent 198.18.128.101
HostRoot 198.18.128.101
HostSubmit 198.18.128.101
SimulationPath /nobackup/root/pyvxr/p0lcc0lc0
SimulationPid 8101-32H
SimulationPlugin matilda32
monitor0 45889
redir0 0
serial0 46357     <-------------------------- Console Port
serial1 43835
simID f30ff037-c6cf-4a4d-9a98-04e7f228447f
```

2. Telnet to console port and login using cisco/cisco123:
```
telnet localhost 46357
```
Example output:
```
cisco@linux-host-1:~$ telnet localhost 46357
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.

sonic-rtr-leaf-1 login: cisco
Password: 
<output truncated>

cisco@sonic-rtr-leaf-1:~$ 
```

3. Check to see if management interface eth0 has its static 192.168.10x address or some DHCP address.
```
show ip interfaces
```
Example output where eth0 has the old DHCP address
```
cisco@sonic-rtr-leaf-1:~$ show ip interfaces
Interface    Master    IPv4 address/mask    Admin/Oper    BGP Neighbor    Neighbor IP
-----------  --------  -------------------  ------------  --------------  -------------
docker0                240.127.1.1/24       up/down       N/A             N/A
eth0                   192.168.122.45/24 <-------- WRONG ADDRESS    
```

4. Use SONiC CLI to replace the IP per Table 1 and save config:

**Table 1**
| Host name  | IP Address     | 
|:-----------|:---------------|
| sonic-rtr-leaf-1     | 192.168.122.101/24  | 
| sonic-rtr-leaf-2     | 192.168.122.102/24  | 
| sonic-rtr-spine-1    | 192.168.122.103/24  |
| sonic-rtr-spine-2    | 192.168.122.104/24  | 

```
sudo config interface ip remove eth0 192.168.122.45/24
sudo config interface ip add eth0 192.168.122.101/24
sudo config save -y
```

1. Use "ctrl ]" and type "quit" at the telnet> prompt to exit the console. You should now be able to ping and ssh to the newly assigned mgt IP
