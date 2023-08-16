


   
1. We'll use an Ansible playbook to apply global configurations to our nodes. cd into the ansible directory and run the lab-1-configs.yml playbook. This playbook will perform the following on each router:
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
1. Next ssh into the routers (notice the hostname change) 
```
ssh cisco@172.10.10.2
vtysh
```

1. The routers' interfaces won't be immediately available after config reload. Wait for interfaces to come up before proceeding to the next step. Use any of the following to verify interfaces:

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

8. Invoke the FRR CLI with the vtysh command, example:
```
cisco@leaf01:~$ vtysh

Hello, this is FRRouting (version 8.2.2).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

leaf01# 
```

9.  FRR is a whole lot like IOS:

```
show run
conf t
show interface brief 
```

Proceed to Lab 2 - FRR ISIS and BGP configuration

cisco@vsonic:~$ docker ps
CONTAINER ID   IMAGE                 COMMAND                  CREATED        STATUS        PORTS     NAMES
1a3000d7b09d   c8000-clab-sonic:29   "/etc/prepEnv.sh /no…"   16 hours ago   Up 16 hours             clab-c8201-sonic-4-node-clos-leaf02
a83fca5cf9c6   c8000-clab-sonic:29   "/etc/prepEnv.sh /no…"   16 hours ago   Up 16 hours             clab-c8201-sonic-4-node-clos-leaf01
9ae30924831e   c8000-clab-sonic:29   "/etc/prepEnv.sh /no…"   16 hours ago   Up 16 hours             clab-c8201-sonic-4-node-clos-spine02
2cb043c24083   c8000-clab-sonic:29   "/etc/prepEnv.sh /no…"   16 hours ago   Up 16 hours             clab-c8201-sonic-4-node-clos-spine01
cisco@vsonic:~$ docker logs -f  clab-c8201-sonic-4-node-clos-leaf02 | grep Router
Router failed to come up
^C
cisco@vsonic:~$ man docker log
--Man-- next: log(3) [ view (return) | skip (Ctrl-D) | quit (Ctrl-C) ]
^C
cisco@vsonic:~$ docker logs | grep clab-c8201-sonic-4-node-clos-leaf02
"docker logs" requires exactly 1 argument.
See 'docker logs --help'.

Usage:  docker logs [OPTIONS] CONTAINER

Fetch the logs of a container
cisco@vsonic:~$ docker logs clab-c8201-sonic-4-node-clos-leaf02 | grep Router
Router failed to come up
