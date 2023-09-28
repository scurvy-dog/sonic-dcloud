# Lab Exercise 5: BFD and End to end testing and traffic generation [20 Min]

insert TOC here

## BFD 

SONiC has FRR running in its "BGP" container. By default the FRR/BGP container is only running the bgpd process. To enable additional FRR daemons such as ISIS or BFD we need to 'exec' into the container and enable the daemon:

1. docker exec into the BGP container in each router

```
docker exec -it bgp bash
```

2. cd into / and enable the bfdd process to run in background:

```
cd /usr/lib/frr
./bfdd &
```

Example:
```
root@spine01:/# cd /usr/lib/frr
root@spine01:/usr/lib/frr# ./bfdd &
[1] 370
root@spine01:/usr/lib/frr# 
```

### configure BFD
1. start bfd daemon
   
2. configure BFD on spine-1
```
vtysh
conf t
```
```
bfd
 peer 10.1.1.0
 peer 10.1.1.6
 exit
 !
router bgp 65000
 neighbor 10.1.1.0 bfd
 neighbor 10.1.1.6 bfd
```

1. configure BFD on leaf-1
```
vtysh
conf t
```
```
bfd
 peer 10.1.1.1
 peer 10.1.1.3
 exit
 !
router bgp 65001
 neighbor 10.1.1.1 bfd
 neighbor 10.1.1.3 bfd
```

1. config BFD on spine-2
```
bfd
 peer 10.1.1.2
 peer 10.1.1.4
 exit
 !
router bgp 65000
 neighbor 10.1.1.2 bfd
 neighbor 10.1.1.4 bfd
```

1. config BFD on leaf-2
```
bfd
 peer 10.1.1.5
 peer 10.1.1.7
 exit
 !
router bgp 65002
 neighbor 10.1.1.5 bfd
 neighbor 10.1.1.7 bfd
```

1. Verify BFD sessions:

```
leaf-1# show bfd peer 10.1.1.1
BFD Peer:
	peer 10.1.1.1 vrf default
		ID: 2663753925
		Remote ID: 1540583716
		Active mode
		Status: up            <---- We are looking for this
		Uptime: 41 second(s)
		Diagnostics: ok
		Remote diagnostics: ok
		Peer Type: configured
		RTT min/avg/max: 0/0/0 usec
		Local timers:
			Detect-multiplier: 3
			Receive interval: 300ms
			Transmission interval: 300ms
			Echo receive interval: 50ms
			Echo transmission interval: disabled
		Remote timers:
			Detect-multiplier: 3
			Receive interval: 300ms
			Transmission interval: 300ms
			Echo receive interval: 50ms

leaf-1# 
```

## End of Intro to SONiC Lab
Please proceed to [SONiC 102 Lab](https://github.com/scurvy-dog/sonic-dcloud/2-SONiC_102/readme.md)
