## Validate Lab Topology


### Validate Client VMs

__Endpoint-1__

In our lab the Endpoint-1 VM represents a standard linux host or endpoint connected to leaf-1, and is essentially a customer/user of our network.

1. SSH to Endpoint-1 Client VM from your laptop.
   ```
   ssh cisco@198.18.128.105
   ```

__Endpoint-2__

The Endpiont-2 VM represents a standard linux host or endpoint connected to leaf-2. Like Endpoint-1, Endpoint-2 is a customer/user of our network.

1. SSH to Endpoint-2 Client VM from your laptop.
   ```
   ssh cisco@198.18.128.106
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
