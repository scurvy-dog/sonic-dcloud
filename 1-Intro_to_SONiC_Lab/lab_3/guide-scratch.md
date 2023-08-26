## Validate Lab Topology

```Markdown
IPv6 Unicast Summary (VRF default):
BGP router identifier 10.0.0.3, local AS number 65000 vrf-id 0
BGP table version 3
RIB entries 6, using 1152 bytes of memory
Peers 2, using 1449 KiB of memory

Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt Desc
**fc00:0:ffff::2**  4      65004         9         8        0    0    0 00:02:10            1        3 N/A**
fc00:0:ffff::4  4      65005        30        28        0    0    0 00:18:26            1        3 N/A
```

### Validate Client VMs

__Endpoint-1__

In our lab the Rome VM represents a standard linux host or endpoint, and is essentially a customer/user of our network.

1. SSH to Endpoint-1 Client VM from your laptop.
   ```
   ssh cisco@198.18.128.103
   ```

__Endpoint-2__

The Endpiont-2 VM represents a VM belonging in another virtual network (different then Endpoint-1 VM). The Endpoint-1 VM comes with 

1. SSH to Endpoint-2 Client VM from your laptop.
   ```
   ssh cisco@198.18.128.102
   ```

### lab 3 playbook
configures FRR BGP on spin01, spine02, and leaf02

```
ansible-playbook -i hosts lab_2-playbook.yml -e "ansible_user=cisco ansible_ssh_pass=cisco123 ansible_sudo_pass=cisco123" -vv
```

### validate BGP
```
spine02# show bgp sum

IPv4 Unicast Summary (VRF default):
BGP router identifier 10.0.0.3, local AS number 65000 vrf-id 0
BGP table version 3
RIB entries 5, using 960 bytes of memory
Peers 2, using 1449 KiB of memory

Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt Desc
10.1.1.2        4      65004         9         8        0    0    0 00:02:12            1        3 N/A
10.1.1.4        4      65005        25        34        0    0    0 00:08:25            1        3 N/A

Total number of neighbors 2

IPv6 Unicast Summary (VRF default):
BGP router identifier 10.0.0.3, local AS number 65000 vrf-id 0
BGP table version 3
RIB entries 6, using 1152 bytes of memory
Peers 2, using 1449 KiB of memory

Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt Desc
fc00:0:ffff::2  4      65004         9         8        0    0    0 00:02:10            1        3 N/A
fc00:0:ffff::4  4      65005        30        28        0    0    0 00:18:26            1        3 N/A

Total number of neighbors 2
spine02# show bgp ipv4 uni
BGP table version is 3, local router ID is 10.0.0.3, vrf id 0
Default local pref 100, local AS 65000
Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
               i internal, r RIB-failure, S Stale, R Removed
Nexthop codes: @NNN nexthop's vrf id, < announce-nh-self
Origin codes:  i - IGP, e - EGP, ? - incomplete
RPKI validation codes: V valid, I invalid, N Not found

    Network          Next Hop            Metric LocPrf Weight Path
 *> 10.0.0.3/32      0.0.0.0                  0         32768 i
 *> 10.0.0.4/32      10.1.1.2                 0             0 65004 i
 *> 10.0.0.5/32      10.1.1.4                 0             0 65005 i

Displayed  3 routes and 3 total paths
spine02# show bgp ipv6 uni
BGP table version is 3, local router ID is 10.0.0.3, vrf id 0
Default local pref 100, local AS 65000
Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
               i internal, r RIB-failure, S Stale, R Removed
Nexthop codes: @NNN nexthop's vrf id, < announce-nh-self
Origin codes:  i - IGP, e - EGP, ? - incomplete
RPKI validation codes: V valid, I invalid, N Not found

    Network          Next Hop            Metric LocPrf Weight Path
    fc00:0:3::/48    ::                       0         32768 i
 *> fc00:0:3::1/128  ::                       0         32768 i
 *> fc00:0:4::1/128  fc00:0:ffff::2           0             0 65004 i
 *> fc00:0:5::1/128  fc00:0:ffff::4           0             0 65005 i

Displayed  4 routes and 4 total paths
spine02# 
```

### validate linux IP routes on spines
```
cisco@spine02:~$ ip route
default via 172.10.10.1 dev eth0 metric 202 
10.0.0.4 nhid 99 via 10.1.1.2 dev PortChannel2 proto bgp src 10.0.0.3 metric 20 
10.0.0.5 nhid 93 via 10.1.1.4 dev PortChannel1 proto bgp src 10.0.0.3 metric 20 
10.1.1.2/31 dev PortChannel2 proto kernel scope link src 10.1.1.3 
10.1.1.4/31 dev PortChannel1 proto kernel scope link src 10.1.1.5 
172.10.10.0/24 dev eth0 proto kernel scope link src 172.10.10.3 metric 202 
240.127.1.0/24 dev docker0 proto kernel scope link src 240.127.1.1 linkdown 
```

### validate linux IP routes on leaf
```
cisco@leaf01:~$ ip route
10.0.0.2 nhid 228 via 10.1.1.1 dev PortChannel1 proto bgp src 10.0.0.4 metric 20 
10.0.0.3 nhid 232 via 10.1.1.3 dev PortChannel2 proto bgp src 10.0.0.4 metric 20 
10.0.0.5 nhid 233 proto bgp src 10.0.0.4 metric 20 
	nexthop via 10.1.1.1 dev PortChannel1 weight 1 
	nexthop via 10.1.1.3 dev PortChannel2 weight 1 
10.1.1.0/31 dev PortChannel1 proto kernel scope link src 10.1.1.0 
10.1.1.2/31 dev PortChannel2 proto kernel scope link src 10.1.1.2 
10.1.2.0/24 dev Ethernet16 proto kernel scope link src 10.1.2.1 
172.10.10.0/24 dev eth0 proto kernel scope link src 172.10.10.4 
240.127.1.0/24 dev docker0 proto kernel scope link src 240.127.1.1 linkdown 
```
