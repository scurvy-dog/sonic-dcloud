# SONiC 101 - Exercise 3: Configure and Validate BGP [40 Min]

### Description: 
In Exercise 3 we will explore configuring the BGP routing protocol within SONiC

## Contents
- [SONiC 101 - Exercise 3: Configure and Validate BGP \[40 Min\]](#sonic-101---exercise-3-configure-and-validate-bgp-40-min)
    - [Description:](#description)
  - [Contents](#contents)
  - [Lab Objectives](#lab-objectives)
  - [FRR BGP Overview](#frr-bgp-overview)
  - [BGP Topology](#bgp-topology)
  - [Ansible BGP Playbook](#ansible-bgp-playbook)
  - [Configure BGP sonic-rtr-leaf-1 with FRR CLI](#configure-bgp-sonic-rtr-leaf-1-with-frr-cli)
  - [Validate BGP Peering](#validate-bgp-peering)
    - [Verify BGP Peering Sessions](#verify-bgp-peering-sessions)
    - [Verify BGP Routing Table](#verify-bgp-routing-table)
    - [IPv4 BGP Route Validation Walk Through](#ipv4-bgp-route-validation-walk-through)
    - [Validate the route was installed in the Linux forwarding table (SONiC's FIB)](#validate-the-route-was-installed-in-the-linux-forwarding-table-sonics-fib)
  - [Validate SONiC End to End Connectivity](#validate-sonic-end-to-end-connectivity)
    - [Validate sonic-rtr-leaf-1 to sonic-rtr-leaf-2 reachability](#validate-sonic-rtr-leaf-1-to-sonic-rtr-leaf-2-reachability)
    - [Validate Endpoint-1 to Endpoint-2 reachability](#validate-endpoint-1-to-endpoint-2-reachability)
  - [End of Lab Exercise 3](#end-of-lab-exercise-3)
  
## Lab Objectives
Upon completion of Lab 3 the student should have achieved the following objectives:

* Understand FRR configuration
* How to validate and troubleshoot FRR BGP sessions
* Valadiate end to end topology 

## FRR BGP Overview
For this lab we will be using two mechanisms to configure FRR. The first is to use ansible to execute a vtysh -f <filename> command to push the config file to leaf-2 and spines 1 and 2.

For *sonic-rtr-leaf-1* we'll invoke the FRR CLI and manually configure BGP  

## BGP Topology
Our four node fabric runs eBGP peering sessions across three separate BGP ASNs. The spine layer will run a single AS 65000. Each leaf will run a separate BGP AS as represented in the topology diagram below. In this BGP DC fabric the leafs should be receiving equal cost paths through each of the spine layer port-channels via AS 65000.

![BGP Topology](./topo-drawings/bgp-topology.png)

## Ansible BGP Playbook

There are several relevant files for our ansible playbook

| Name                        | Location               | Notes                         |
|:----------------------------|:-----------------------|:------------------------------|
| lab_exercise_3-playbook.yml | /ansible/              | Ansible playbook file         |
| hosts                       | /ansible/              | Contains device list and IPs  |
| frr.conf                    | /ansible/files/{host}/ | FRR BGP file -> bgpd.conf     |


1. Log into the *linux-host-1* VM.
2. Change to the ansible directory
   ```
   cd ~/sonic-dcloud/1-SONiC_101/ansible
   ```
   
3. Run the Ansible playbook to copy configurations to SONiC routers and load them via vtysh
   ```
   ansible-playbook -i hosts lab_exercise_3-playbook.yml -e "ansible_user=cisco ansible_ssh_pass=cisco123 ansible_sudo_pass=cisco123" -vv
   ```

   You should expect a large amount of output from ansible but, at the end of logs look for the following output
   ```
   PLAY RECAP **************************************************************************************************************************
   sonic-rtr-leaf-2           : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
   sonic-rtr-spine-1          : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
   sonic-rtr-spine-2          : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
   ```
   
> [!IMPORTANT]
> Ansible playbook configured router *sonic-rtr-spine-1*, *sonic-rtr-spine-2*, and *sonic-rtr-leaf-2*. Next we'll manually configure BGP for *sonic-rtr-leaf-1*.
   
## Configure BGP sonic-rtr-leaf-1 with FRR CLI
1. From linux-host-1 SSH to SONiC router *sonic-rtr-leaf-1* (ssh cisco@leaf-1) and invoke the FRR CLI shell
   ```
   vtysh
   ```
2. Enter into FRR configuration mode.
   ```
   config terminal
   ```
3. Start with the base BGP configuration. For *sonic-rtr-leaf-1* we will be using AS65001 per the topology diagram. Enter the below CLI commands.
   ```
   router bgp 65001
   bgp router-id 10.0.0.1
   bgp log-neighbor-changes
   no bgp ebgp-requires-policy
   no bgp default ipv4-unicast
   timers bgp 3 9
   bgp bestpath as-path multipath-relax
   neighbor 10.1.1.1 remote-as 65000
   neighbor 10.1.1.3 remote-as 65000
   neighbor fc00:0:ffff::1 remote-as 65000
   neighbor fc00:0:ffff::3 remote-as 65000
   ```
4. Next we will add the IPv4 Unicast configuration and advertise sonic-rtr-leaf-1's loopback and endpoint attached prefix 198.18.11.0/24
   ```
   address-family ipv4 unicast
   network 10.0.0.1/32
   network 198.18.11.0/24
   neighbor 10.1.1.1 activate
   neighbor 10.1.1.3 activate
   exit-address-family
   ```
5. Now add the IPv6 Unicast configuration 
   ```
   address-family ipv6 unicast
   network fc00:0:1::/48
   network fc00:0:1::1/128
   neighbor fc00:0:ffff::1 activate
   neighbor fc00:0:ffff::3 activate
   exit-address-family
   exit
   ```
6. Verify the new running configuration in FRR
   ```
   sonic-rtr-leaf-1# show running-config
   ...
   router bgp 65001
     bgp router-id 10.0.0.1
     bgp log-neighbor-changes
     no bgp ebgp-requires-policy
     no bgp default ipv4-unicast
     bgp bestpath as-path multipath-relax
     timers bgp 3 9
     neighbor 10.1.1.1 remote-as 65000        <---- sonic-rtr-spine-1 IPv4 Peer
     neighbor 10.1.1.3 remote-as 65000        <---- sonic-rtr-spine-2 IPv4 Peer
     neighbor fc00:0:ffff::1 remote-as 65000  <---- sonic-rtr-spine-1 IPv6 Peer
     neighbor fc00:0:ffff::3 remote-as 65000  <---- sonic-rtr-spine-2 IPv6 Peer
   !
   address-family ipv4 unicast
     network 10.0.0.1/32                      <---- Advertise local IPv4 network
     network 198.18.11.0/24                   <---- Advertise "endpoint" IPv4 network
     neighbor 10.1.1.1 activate
     neighbor 10.1.1.3 activate
   exit-address-family
   !
   address-family ipv6 unicast
     network fc00:0:1::/48                    <---- Advertise local IPv6 network
     network fc00:0:1::1/128                  <---- Advertise local IPv6 network
     neighbor fc00:0:ffff::1 activate
     neighbor fc00:0:ffff::3 activate
   exit-address-family
   exit
   !
   ```
7. Write the config to memory:
   ```
   write
   ```
   ```
   sonic-rtr-leaf-1# write
   Note: this version of vtysh never writes vtysh.conf
   Building Configuration...
   Configuration saved to /etc/frr/zebra.conf
   Configuration saved to /etc/frr/bgpd.conf
   Configuration saved to /etc/frr/staticd.conf
   ```

## Validate BGP Peering

### Verify BGP Peering Sessions
> [!NOTE]
> FRR routing *show* commands must be done within the *vtysh* shell

1. Log into SONiC router *sonic-rtr-leaf-1* and invoke vtysh
2. Verify that BGP peering sessions are established with *sonic-rtr-spine-1* and *sonic-rtr-spine-2*
     ```
     show bgp summary
     ```
     ```
     sonic-rtr-leaf-1# show bgp summary
     IPv4 Unicast Summary (VRF default)
     BGP router identifier 10.0.0.4, local AS number 65001 vrf-id 0
     BGP table version 4
     RIB entries 7, using 1344 bytes of memory
     Peers 2, using 1449 KiB of memory

     Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt Desc
     10.1.1.1        4      65000        10        10        0    0    0 00:04:03            3        6 N/A    <--- sonic-rtr-spine-1
     10.1.1.3        4      65000        10        10        0    0    0 00:04:03            3        6 N/A    <--- sonic-rtr-spine-2

     Total number of neighbors 2

     IPv6 Unicast Summary (VRF default):
     BGP router identifier 10.0.0.4, local AS number 65001 vrf-id 0
     BGP table version 11
     RIB entries 8, using 1536 bytes of memory
     Peers 2, using 1449 KiB of memory

     Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt Desc
     fc00:0:ffff::1  4      65000        47        52        0    0    0 00:22:32            2        4 N/A
     fc00:0:ffff::3  4      65000        47        54        0    0    0 00:22:32            2        4 N/A

     Total number of neighbors 2
     ```
  
3. Log into SONiC router *sonic-rtr-leaf-2*
4. Verify that BGP peering sessions are established with *sonic-rtr-spine-1* and *sonic-rtr-spine-2*
     ```
     sonic-rtr-leaf-2# show bgp summary
     IPv4 Unicast Summary (VRF default):
     BGP router identifier 10.0.0.2, local AS number 65002 vrf-id 0
     BGP table version 6
     RIB entries 11, using 2024 bytes of memory
     Peers 2, using 1447 KiB of memory

     Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt Desc
     10.1.1.5        4      65000      1453      1453        0    0    0 01:12:20            3        6 N/A
     10.1.1.7        4      65000      1453      1453        0    0    0 01:12:20            3        6 N/A

     Total number of neighbors 2

     IPv6 Unicast Summary (VRF default):
     BGP router identifier 10.0.0.2, local AS number 65002 vrf-id 0
     BGP table version 5
     RIB entries 8, using 1472 bytes of memory
     Peers 2, using 1447 KiB of memory

     Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt Desc
     fc00:0:ffff::5  4      65000      1456      1457        0    0    0 01:12:20            2        5 N/A
     fc00:0:ffff::7  4      65000      1456      1457        0    0    0 01:12:20            2        5 N/A

     Total number of neighbors 2
     ```

### Verify BGP Routing Table
We've listed a number of verification steps to show various options from within the FRR CLI. Feel free to do all, or just some of these steps.

5. **Verify IPv4** routes. SONiC router *sonic-rtr-leaf-1* should have received the following
     ```
     show ip route bgp
     ```
     ```
     sonic-rtr-leaf-1# show ip route bgp
     Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure
     B>* 10.0.0.2/32 [20/0] via 10.1.1.1, PortChannel1, weight 1, 00:05:22  
     *                    via 10.1.1.3, PortChannel2, weight 1, 00:05:22
     B>* 10.0.0.3/32 [20/0] via 10.1.1.1, PortChannel1, weight 1, 00:05:22
     B>* 10.0.0.4/32 [20/0] via 10.1.1.3, PortChannel2, weight 1, 03:09:17
     B>* 198.18.12.0/24 [20/0] via 10.1.1.1, PortChannel1, weight 1, 00:05:22 <--- sonic-rtr-leaf-2 Route via sonic-rtr-spine-1
     *                       via 10.1.1.3, PortChannel2, weight 1, 00:05:22   <--- sonic-rtr-leaf-2 Route via sonic-rtr-spine-2
     ```
6. **Verify IPv4** routes. SONiC router *sonic-rtr-leaf-2* should have received the following
     ```
     sonic-rtr-leaf-1# show ip route bgp
     Codes: K - kernel route, C - connected, S - static, R - RIP,
          O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
          T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
          f - OpenFabric,
          > - selected route, * - FIB route, q - queued, r - rejected, b - backup
          t - trapped, o - offload failure

     B>* 10.0.0.1/32 [20/0] via 10.1.1.5, PortChannel1, weight 1, 01:13:29
       *                    via 10.1.1.7, PortChannel2, weight 1, 01:13:29
     B>* 10.0.0.3/32 [20/0] via 10.1.1.7, PortChannel2, weight 1, 01:13:29
     B>* 10.0.0.4/32 [20/0] via 10.1.1.5, PortChannel1, weight 1, 01:13:29
     B>* 198.18.11.0/24 [20/0] via 10.1.1.5, PortChannel1, weight 1, 01:13:29  <--- sonic-rtr-leaf-1 Route via sonic-rtr-spine-1
      *                       via 10.1.1.7, PortChannel2, weight 1, 01:13:29   <--- sonic-rtr-leaf-2 Route via sonic-rtr-spine-1
     ```
  
7. **Verify IPv6** SONiC router *sonic-rtr-leaf-1* should have received the following.
     ```
     show ipv6 route bgp
     ```
     ```
     sonic-rtr-leaf-1# show ipv6 route bgp
     Codes: K - kernel route, C - connected, S - static, R - RIPng,
          O - OSPFv3, I - IS-IS, B - BGP, N - NHRP, T - Table,
          v - VNC, V - VNC-Direct, A - Babel, F - PBR,
          f - OpenFabric,
          > - selected route, * - FIB route, q - queued, r - rejected, b - backup
          t - trapped, o - offload failure

     B>* fc00:0:2::/48 [20/0] via fe80::5054:ff:fe74:c103, PortChannel1, weight 1, 00:02:45
       *                      via fe80::7acf:d2ff:fe73:b600, PortChannel2, weight 1, 00:02:45
     B>* fc00:0:2::1/128 [20/0] via fe80::5054:ff:fe74:c103, PortChannel1, weight 1, 00:02:45
       *                        via fe80::7acf:d2ff:fe73:b600, PortChannel2, weight 1, 00:02:45
     B>* fc00:0:3::1/128 [20/0] via fe80::5054:ff:fe74:c103, PortChannel1, weight 1, 01:59:54
     B>* fc00:0:4::1/128 [20/0] via fe80::7acf:d2ff:fe73:b600, PortChannel2, weight 1, 01:59:54
     ```
     - *sonic-rtr-leaf-2* should show similar output.
  
8. Examine IPv4 BGP AS Path information in the route table. This shows us what routes are installed in the BGP table vs which routes are installed into the routing table.
     ```
     show bgp ipv4 unicast
     ```
     ```
     sonic-rtr-leaf-1# show bgp ipv4 uni
     BGP table version is 6, local router ID is 10.0.0.1, vrf id 0
     Default local pref 100, local AS 65001
     Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
                  i internal, r RIB-failure, S Stale, R Removed
     Nexthop codes: @NNN nexthop's vrf id, < announce-nh-self
     Origin codes:  i - IGP, e - EGP, ? - incomplete
     RPKI validation codes: V valid, I invalid, N Not found

       Network          Next Hop            Metric LocPrf Weight Path
     *> 10.0.0.1/32      0.0.0.0                  0         32768 i
     *> 10.0.0.2/32      10.1.1.1                               0 65000 65002 i
     *=                  10.1.1.3                               0 65000 65002 i
     *> 10.0.0.3/32      10.1.1.1                 0             0 65000 i
     *> 10.0.0.4/32      10.1.1.3                 0             0 65000 i
     *> 198.18.11.0/24   0.0.0.0                  0         32768 i
     *= 198.18.12.0/24   10.1.1.3                               0 65000 65002 i
     *>                  10.1.1.1                               0 65000 65002 i
     Displayed  6 routes and 8 total paths
     ```

9. Examine IPv6 BGP AS Path information in the route table
     ```
     sonic-rtr-leaf-1# show bgp ipv6 uni
     BGP table version is 5, local router ID is 10.0.0.1, vrf id 0
     Default local pref 100, local AS 65001
     Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
                  i internal, r RIB-failure, S Stale, R Removed
     Nexthop codes: @NNN nexthop's vrf id, < announce-nh-self
     Origin codes:  i - IGP, e - EGP, ? - incomplete
     RPKI validation codes: V valid, I invalid, N Not found

       Network           Next Hop            Metric LocPrf Weight Path
       fc00:0:1::/48     ::                       0         32768 i
     *> fc00:0:1::1/128  ::                       0         32768 i
     *= fc00:0:2::1/128  fe80::7afe:fdff:feb2:6800
                                                              0 65000 65002 i
     *>                  fe80::7a58:c8ff:fe83:e400
                                                              0 65000 65002 i
     *> fc00:0:3::1/128  fe80::7afe:fdff:feb2:6800
                                                0             0 65000 i
     *> fc00:0:4::1/128  fe80::7a58:c8ff:fe83:e400
                                                0             0 65000 i
     Displayed  5 routes and 6 total paths
     ```

### IPv4 BGP Route Validation Walk Through
Validate IPv4 BGP route received from peer. We will examine *10.0.0.2/32* originated from *sonic-rtr-leaf-2*

10. Validate route was received from *sonic-rtr-spine-1* and *sonic-rtr-spine-2* and added to the BGP table
     ```
     show ip bgp 10.0.0.2/32
     ```
     ```
     sonic-rtr-leaf-1# show ip bgp 10.0.0.2/32
     BGP routing table entry for 10.0.0.2/32, version 4
     Paths: (2 available, best #1, table default)
       Advertised to non peer-group peers:
       10.1.1.1 10.1.1.3
       65000 65002
         10.1.1.1 from 10.1.1.1 (10.0.0.3)
           Origin IGP, valid, external, multipath, best (Router ID)
           Last update: Mon Sep 18 20:37:32 2023
       65000 65002
         10.1.1.3 from 10.1.1.3 (10.0.0.4)
           Origin IGP, valid, external, multipath
           Last update: Mon Sep 18 20:37:32 2023
     ```
11. Validate that BGP route was installed into the routing information base (RIB)
     ```
     show ip route 10.0.0.2/32
     ```
     ```
     sonic-rtr-leaf-1# show ip route 10.0.0.2/32
     Routing entry for 10.0.0.2/32
       Known via "bgp", distance 20, metric 0, best
       Last update 00:10:55 ago
       * 10.1.1.1, via PortChannel1, weight 1
       * 10.1.1.3, via PortChannel2, weight 1
     ```

### Validate the route was installed in the Linux forwarding table (SONiC's FIB)

12. Exit the FRR CLI and then from display the Linux IP routing table:
     ```
     cisco@sonic-rtr-leaf-1:~$ ip route
     10.0.0.2 nhid 121 proto bgp src 10.0.0.1 metric 20       
       nexthop via 10.1.1.3 dev PortChannel2 weight 1        <--- sonic-rtr-leaf-2 Route via sonic-rtr-spine-2
       nexthop via 10.1.1.1 dev PortChannel1 weight 1        <--- sonic-rtr-leaf-2 Route via sonic-rtr-spine-1
     10.0.0.3 nhid 113 via 10.1.1.1 dev PortChannel1 proto bgp src 10.0.0.1 metric 20 
     10.0.0.4 nhid 112 via 10.1.1.3 dev PortChannel2 proto bgp src 10.0.0.1 metric 20 
     10.1.1.0/31 dev PortChannel1 proto kernel scope link src 10.1.1.0 
     10.1.1.2/31 dev PortChannel2 proto kernel scope link src 10.1.1.2 
     192.168.122.0/24 dev eth0 proto kernel scope link src 192.168.122.101 
     192.168.123.0/24 dev eth4 proto kernel scope link src 192.168.123.4 
     198.18.11.0/24 dev Ethernet32 proto kernel scope link src 198.18.11.1 
     198.18.12.0/24 nhid 121 proto bgp src 10.0.0.1 metric 20 
       nexthop via 10.1.1.3 dev PortChannel2 weight 1 
       nexthop via 10.1.1.1 dev PortChannel1 weight 1 
     ```

## Validate SONiC End to End Connectivity

### Validate sonic-rtr-leaf-1 to sonic-rtr-leaf-2 reachability
1. From *sonic-rtr-leaf-1* we will ping the *loopback0* interface on *sonic-rtr-leaf-2*
     ```
     ping 10.0.0.2
     ```
     ```
     sonic-rtr-leaf-1# ping 10.0.0.2
     PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.
     64 bytes from 10.0.0.2: icmp_seq=1 ttl=63 time=101 ms
     64 bytes from 10.0.0.2: icmp_seq=2 ttl=63 time=276 ms
     ```

### Validate Endpoint-1 to Endpoint-2 reachability

*endpoint-1* VM represents a standard linux host or endpoint connected to SONiC router *sonic-rtr-leaf-1*. 
*endpoint-2* VM represents a standard linux host or endpoint connected to SONiC router *sonic-rtr-leaf-2*.

2. Open a new terminal and SSH to Endpoint-1 Client VM
     ```
     ssh cisco@198.18.128.105
     ```

3. Ping Endpoint-2
     ```
     ping 198.18.12.2
     ```
     ```
     cisco@endpoint-1:~$ ping 198.18.12.2
     PING 198.18.12.2 (198.18.12.2) 56(84) bytes of data.
     64 bytes from 198.18.12.2: icmp_seq=1 ttl=62 time=698 ms
     64 bytes from 198.18.12.2: icmp_seq=2 ttl=62 time=372 ms
     ```

## End of Lab Exercise 3
Please proceed to [Lab 4](https://github.com/scurvy-dog/sonic-dcloud/blob/main/1-SONiC_101/lab_exercise_4.md)
