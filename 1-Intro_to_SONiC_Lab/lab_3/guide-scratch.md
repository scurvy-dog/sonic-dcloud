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

The Endpiont-2 VM represents a VM belonging in another virtual network (different then Endpoint-1 VM). The Endpoint-1 VM comes with 
VPP pre-installed. VPP (also known as https://fd.io/) is a very flexible and high performance open source software dataplane. 

1. SSH to Endpoint-2 Client VM from your laptop.
   ```
   ssh cisco@198.18.128.102
   ```

2. Check that the VPP interface facing Ubuntu (host-vpp-in) and the interface facing router xrd01 (GigabitEthernetb/0/0) are `UP` 
and have their assigned IP addresses. GigabitEthernetb/0/0: `10.101.1.1/24`, and host-vpp-in: `10.101.2.2/24` 
    
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

