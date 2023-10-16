# Troubleshooting the lab

## Contents
- [Troubleshooting the lab](#troubleshooting-the-lab)
  - [Contents](#contents)
  - [Typical Issues](#typical-issues)
    - [Manual VXR Rebuild](#manual-vxr-rebuild)
    - [No Data Interfaces](#no-data-interfaces)
  
## Typical Issues
There are two potential scenarioes where trouble may happen with the SONiC node. In both cases the fastest remediation is to have the container torn down and rebuilt. Be aware that once the container is back up and running configuration would need to be reapplied.

1. Initial SONiC node fails to populate interfaces from the Cisco 8000 Emulator
2. The SONiC node has general container instability which can happen in the virtual environment

### Manual VXR Rebuild

1. ssh to the sonic node's host VM:

     | Host name  | IP Address     |
     |:-----------|:---------------|
     | linux-host-1  | 198.18.128.101 |
     | linux-host-2  | 198.18.128.102 |
     | linux-host-3 | 198.18.128.103 |
     | linux-host-4 | 198.18.128.104 |

2. Determine the local SONiC/8000 container's name:
   ```
   docker ps
   ```
   Example output:
   ```
   cisco@linux-host-4:~$ docker ps
   CONTAINER ID   IMAGE                 COMMAND                  CREATED          STATUS          PORTS     NAMES
   d1861990e9a8   c8000-clab-sonic:31   "/etc/prepEnv.sh /no…"   21 minutes ago   Up 21 minutes             clab-c8101-sonic-sonic-rtr-spine-2
   cisco@linux-host-4:~$
   ```

3. Access the docker container through an exec shell:
   ```
   docker exec -it <container name or ID> bash
   ```
   Example:
   ```
   docker exec -it clab-c8101-sonic-sonic-rtr-spine-2 bash
   ```

4. change directory into 'nobackup'
   ```
   cd nobackup
   ```

5. Run the startup.sh shell script as follows:

   If *sonic-rtr-leaf-1* or *sonic-rtr-leaf-2* failed:
   ```
   ./startup.sh 8000.yaml 5
   ```

   if *sonic-rtr-spine-1* or *sonic-rtr-spine-2* failed:
   ```
   ./startup.sh 8000.yaml 4
   ```

6. The script will output log info very similar to the docker logs info. The script will monitor the SONiC node and test to see if the Cisco 8000 emulator has created interfaces for the SONiC node. Expect about 10-12 minutes to see a 'Router up' message. 

   Truncated example output:
   ```
   cisco@sonic-rtr-spine-2:~$ docker exec -it  clab-c8101-sonic-sonic-rtr-spine-2 bash
   root@sonic-rtr-spine-2:/# cd nobackup/
   root@sonic-rtr-spine-2:/nobackup# ./startup.sh 8000.yaml 4
   Invoking /nobackup/startup.py 8000.yaml 4 4
   ['/nobackup/startup.py', '8000.yaml', '4', '4']
   MGMT_IP: 172.10.10.104  MASK: 255.255.255.0  GATEWAY: 172.10.10.1
   Found 4 data interfaces (expected 4)
   ...
   ...
   22:40:57 INFO R0:onie sonic login cisco/cisco123
   22:40:57 INFO R0:reached sonic prompt
   22:40:57 INFO R0:checking interfaces
   22:41:01 INFO R0:found 0 interfaces (expected 32)
   22:41:32 INFO R0:found 0 interfaces (expected 32)
   22:42:04 INFO R0:found 32 interfaces (expected 32)     <---------- Key Log Message
   22:42:04 INFO R0:applying XR config
   22:42:12 INFO Sim up
   Router up                                              <---------- Key Log Message
   ```


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
