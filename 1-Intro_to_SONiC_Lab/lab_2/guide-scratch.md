# Scratch Guide Lab 2

cisco@spine01:~$ sudo show system-health summary
System status summary

  System status LED  green
  Services:
    Status: OK
  Hardware:
    Status: Not OK
    Reasons: PSU 2 is missing or not available
	     PSU 1 is missing or not available
	     fantray5.fan1 is missing
	     fantray5.fan0 is missing
	     fantray4.fan1 is missing
	     fantray4.fan0 is missing
	     fantray3.fan1 is missing
	     fantray3.fan0 is missing
	     fantray2.fan1 is missing
	     fantray2.fan0 is missing
	     fantray1.fan1 is missing
	     fantray1.fan0 is missing
	     fantray0.fan1 is missing
	     fantray0.fan0 is missing
	     PSU1.fan0 is missing
	     PSU0.fan0 is missing
	     Container 'telemetry' is not running
	     routeCheck is not Status o


### Enter FRR configuration mode
cisco@spine01:/etc/sonic$ vtysh

Hello, this is FRRouting (version 8.2.2).
Copyright 1996-2005 Kunihiro Ishiguro, et al.
spine01# 
### FRR Edit configuration cli
cisco@spine01:/etc/sonic$ vtysh

Hello, this is FRRouting (version 8.2.2).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

spine01# conf t
spine01(config)# 

### FRR write config
spine01# write
Note: this version of vtysh never writes vtysh.conf
Building Configuration...
Configuration saved to /etc/frr/zebra.conf
Configuration saved to /etc/frr/bgpd.conf
Configuration saved to /etc/frr/staticd.conf

### FRR Saved config
cisco@spine01:/etc/sonic$ sudo more /etc/sonic/frr/bgpd.conf
!
! Zebra configuration saved from vty
!   2023/08/16 20:12:12
!
! loaded from 8.4-dev
frr version 8.2.2
frr defaults traditional
