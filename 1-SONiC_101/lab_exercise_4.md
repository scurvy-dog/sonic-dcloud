# SONiC 101 - Exercise 4: Bi-directional Forward Detection (BFD) [20 Min]

### Description: 
In Lab Exercise 4 the student will explore BFD as its currently implemented in SONiC. As we've seen, SONiC has FRR running in its "bgp" docker container. By default the FRR/BGP container runs zebra, staticd, and bgpd daemons, as well as a couple other processes. To enable additional FRR daemons such as ISIS or BFD we need to 'exec' into the container and enable the daemon. Once enabled, we can then vtysh into FRR and apply our BFD configuration.

> [!IMPORTANT]
> BFD is a feature in development within SONiC. In this lab exercise we'll manually enable the BFD daemon and configure BFD, however, the daemon won't persist across router reloads or restarts of the bgp container

## Contents
- [Exercise 4: Bi-directional Forward Detection BFD \[20 Min\]]
    - [Description:](#description)
  - [Lab Objectives](#lab-objectives)
  - [BGP Configuration](#bfd-configuration)
  - [End of Lab 4](#end-of-lab-4)
  
## Lab Objectives
The student upon completion of Lab Exercise 5 should have achieved the following objectives:

* Understand the relationship of FRR process and the SONiC BGP container
* BFD Configuratin in FRR
* Validate BFD sessions

## BFD Configuration

For the purposes of this lab we will enable BFD between *leaf-1* and *spine-1* on the port-channel interface connecting the two routers. See diagram below.
![BFD diagram](./topo-drawings/bfd-overview.png)

You will be manually configuring the BFD configurations on *leaf-1* and *spine-1*. 

1.  SSH to leaf-1 and spine-1 and use docker exec to enable FRR's BFD daemon inside the 'bgp' container:

	```
	docker exec -it bgp /usr/lib/frr/bfdd &
	```

	Example:
	```
	cisco@leaf-1:~$ docker exec -it bgp /usr/lib/frr/bfdd &
	[1] 17877
	```

2.  You can validate the daemon is running using 'ps -eaf'
   
	```
	docker exec -it bgp ps -eaf
	```
	Example output (don't worry about the "Stopped" message at the bottom, the daemon is running in the background):
	```
	cisco@leaf-1:~$ docker exec -it bgp ps -eaf
	UID          PID    PPID  C STIME TTY          TIME CMD
	root           1       0  0 17:11 pts/0    00:00:01 /usr/bin/python3 /usr/local/bin/supervisord
	root          26       1  0 17:11 pts/0    00:00:00 python3 /usr/bin/supervisor-proc-exit-listener --container-name bgp
	root          27       1  0 17:11 pts/0    00:00:00 /usr/sbin/rsyslogd -n -iNONE
	frr           31       1  0 17:12 pts/0    00:00:00 /usr/lib/frr/zebra -A 127.0.0.1 -s 90000000 -M fpm -M snmp
	frr           45       1  0 17:12 pts/0    00:00:00 /usr/lib/frr/staticd -A 127.0.0.1
	frr           46       1  0 17:12 pts/0    00:00:00 /usr/lib/frr/bgpd -A 127.0.0.1 -M snmp
	root          48       1  0 17:12 pts/0    00:00:00 /usr/bin/python3 /usr/local/bin/bgpcfgd
	root          53       1  0 17:12 pts/0    00:00:00 /usr/bin/python3 /usr/local/bin/bgpmon
	root          55       1  0 17:12 pts/0    00:00:00 fpmsyncd
	frr          387       0  0 17:32 pts/1    00:00:00 /usr/lib/frr/bfdd
	root         397       0  0 17:32 pts/2    00:00:00 ps -eaf

	[1]+  Stopped                 docker exec -it bgp /usr/lib/frr/bfdd
	```
### we might use this section if we copy the daemons file over to frr
1.  You can validate the daemon is running with the systemd service command:
   
	```
	service frr status
	```
	Example output:
	```
	root@spine-2:/# service frr status
	Status of watchfrr: running.
	Status of zebra: running.
	Status of bgpd: running.
	Status of staticd: running.
	Status of bfdd: running.
	```

### configure BFD in FRR 
1.  vtysh into FRR on both leaf-1 and spine-1

2.  Configure BFD on leaf-1
	```
	vtysh
	conf t
	```
	```
	bfd
	peer 10.1.1.1
	exit
	!
	router bgp 65001
	neighbor 10.1.1.1 bfd
	```

3.  Configure BFD on spine-1

	```
	vtysh
	conf t
	```
	```
	bfd
	peer 10.1.1.0
	exit
	!
	router bgp 65000
	neighbor 10.1.1.0 bfd
	```

4.  Verify BFD sessions show 'Status: up'

	```
	show bfd peer 10.1.1.1
	```
	```
	leaf-1# show bfd peer 10.1.1.1
	BFD Peers:
		peer 10.1.1.1 vrf default
			ID: 2118180714
			Remote ID: 4205222022
			Active mode
			Status: up                 <------------- 
			Uptime: 3 minute(s), 19 second(s)
			Diagnostics: ok
			Remote diagnostics: ok
			Peer Type: configured
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

5.  We can also run tcpdump on SONiC's Ethernet interfaces to see the BFD packets coming in and out:

	```
	sudo tcpdump -ni Ethernet4 -vv
	```
	Example output:
	```
	cisco@leaf-1:~$ sudo tcpdump -ni Ethernet4 -vv
	tcpdump: listening on Ethernet4, link-type EN10MB (Ethernet), snapshot length 262144 bytes
	18:39:23.206477 IP (tos 0xc0, ttl 255, id 42139, offset 0, flags [DF], proto UDP (17), length 52)
		10.1.1.1.49152 > 10.1.1.0.3784: [udp sum ok] 
		BCM-LI-SHIM: direction unused, pkt-type unknown, pkt-subtype untagged, li-id 792
		(invalid)
	18:39:23.248328 IP (tos 0xc0, ttl 255, id 65413, offset 0, flags [DF], proto UDP (17), length 52)
		10.1.1.0.49152 > 10.1.1.1.3784: [udp sum ok] 
		BCM-LI-SHIM: direction unused, pkt-type unknown, pkt-subtype untagged, li-id 792
		(invalid)
	```

6.  Test convergence by failing an interface...uh, we probably don't want to do this...



## End of Lab 4
Please proceed to [Lab 5](https://github.com/scurvy-dog/sonic-dcloud/blob/main/1-SONiC_101/lab_exercise_5.md)
