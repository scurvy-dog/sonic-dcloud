# Lab Exercise 5: BFD and End to end testing and traffic generation [20 Min]

insert TOC here

## BFD 

SONiC has FRR running in its "BGP" container. By default the FRR/BGP container is only running the bgpd process. To enable additional FRR daemons such as ISIS or BFD we need to 'exec' into the container and enable the daemon:

1. docker exec into BGP container in each router

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
root@spine01:/usr/lib/frr# 2023/09/05 20:37:29 BFD: [ZKB8W-3S2Q4][EC 100663330] unneeded 'destroy' callback for '/frr-bfdd:bfdd/bfd/profile/minimum-ttl'
2023/09/05 20:37:29 BFD: [ZKB8W-3S2Q4][EC 100663330] unneeded 'destroy' callback for '/frr-bfdd:bfdd/bfd/sessions/multi-hop/minimum-ttl'

root@spine01:/usr/lib/frr# 
```
- Note: the unneeded 'destroy' callback message 

### configure BFD
1. start bfd daemon
   
2. config BFD on spine01
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

3. config BFD on leaf01
```
bfd
 peer 10.1.1.1
 peer 10.1.1.3
 exit
 !
router bgp 65004
 neighbor 10.1.1.1 bfd
 neighbor 10.1.1.3 bfd
```

4. config BFD on spine02
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

5. config BFD on leaf02
```
bfd
 peer 10.1.1.5
 peer 10.1.1.7
 exit
 !
router bgp 65005
 neighbor 10.1.1.5 bfd
 neighbor 10.1.1.7 bfd
```

1. Verify BFD sessions:

```
leaf01# show bfd peer 10.1.1.1
BFD Peer:
	peer 10.1.1.1 vrf default
		ID: 2663753925
		Remote ID: 1540583716
		Active mode
		Status: up
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

leaf01# 
```

## End of Intro to SONiC Lab
Please proceed to [SONiC SRv6 Lab](https://github.com/scurvy-dog/sonic-dcloud/blob/main/2-SRv6_Lab/README.md)