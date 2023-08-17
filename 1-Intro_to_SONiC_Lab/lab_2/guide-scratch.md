# Scratch Guide Lab 2

### Run some basic SONiC CLI commands:
```
show ?
show runningconfiguration all
show interfaces status
show ip interfaces
show ipv6 interfaces
show environment 
show platform summary
show platform inventory
```
1. You can view the default startup configuration for the container. The config_db.json file stores the saved configuration of the container. 
    ```
    cat /etc/sonic/config_db.json | more 
    ```
>**Note**
>Any running configuration changes must be written to the config_db.json to persist in reboots

### system checks

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

### other show commands:
cisco@spine01:~$ sudo show platform npu counters 
INFO  ____________________Slice0____________________|____________Slice1___________|____________Slice2___________|____________Slice3___________|____________Slice4___________|____________Slice5___________|
INFO  IFG_RX0 packets          =               0    |IFG_RX2 =               0    |IFG_RX4 =               0    |IFG_RX6 =               0    |IFG_RX8 =              26    |IFG_RX10 =               0    |
INFO  IFG_RX1 packets          =               0    |IFG_RX3 =               0    |IFG_RX5 =               0    |IFG_RX7 =               0    |IFG_RX9 =              57    |IFG_RX11 =               0    |
INFO  IFG_RX0 bytes            =               0    |IFG_RX2 =               0    |IFG_RX4 =               0    |IFG_RX6 =               0    |IFG_RX8 =            3741    |IFG_RX10 =               0    |
INFO  IFG_RX1 bytes            =               0    |IFG_RX3 =               0    |IFG_RX5 =               0    |IFG_RX7 =               0    |IFG_RX9 =            9315    |IFG_RX11 =               0    |
INFO  IFGB_RX0 packets         =               0    |IFG_RX2 =               0    |IFG_RX4 =               0    |IFG_RX6 =               0    |IFG_RX8 =               0    |IFG_RX10 =               0    |
INFO  IFGB_RX1 packets         =               0    |IFG_RX3 =               0    |IFG_RX5 =               0    |IFG_RX7 =               0    |IFG_RX9 =               0    |IFG_RX11 =               0    |
INFO  RXPP IFG0 input packets  =               0    |RXPP2   =               0    |RXPP4   =               0    |RXPP6   =               0    |RXPP8   =               0    |RXPP10   =               0    |
INFO  RXPP IFG1 input packets  =               0    |RXPP3   =               0    |RXPP5   =               0    |RXPP7   =               0    |RXPP9   =               0    |RXPP11   =               0    |
INFO  RXPP IFG0 output packets =               0    |RXPP2   =               0    |RXPP4   =               0    |RXPP6   =               0    |RXPP8   =               0    |RXPP10   =               0    |
INFO  RXPP IFG1 output packets =               0    |RXPP3   =               0    |RXPP5   =               0    |RXPP7   =               0    |RXPP9   =               0    |RXPP11   =               0    |
INFO  SMS IFG0 write packets   =               0    |SMS2    =               0    |SMS4    =               0    |SMS6    =               0    |SMS8    =               0    |SMS 10   =               0    |
INFO  SMS IFG1 write packets   =               0    |SMS3    =               0    |SMS5    =               0    |SMS7    =               0    |SMS9    =               0    |SMS 11   =               0    |
INFO  REASSEMBLY Slc0 packets  =               0    |REAS1   =               0    |REAS2   =               0    |REAS3   =               0    |REAS4   =               0    |REAS5    =               0    |
INFO  PDVOQ Slice0 packets     =               0    |PDVOQ1  =               0    |PDVOQ2  =               0    |PDVOQ3  =               0    |PDVOQ4  =               0    |PDVOQ5   =               0    |
INFO  PDVOQ Slice0 bytes       =               0    |PDVOQ1  =               0    |PDVOQ2  =               0    |PDVOQ3  =               0    |PDVOQ4  =               0    |PDVOQ5   =               0    |
INFO  FILB Slice0 packets      =               0    |FILB1   =               0    |FILB2   =               0    |FILB3   =               0    |FILB4   =               0    |FILB5    =               0    |
INFO  FILB Slice0 bytes        =               0    |FILB1   =               0    |FILB2   =               0    |FILB3   =               0    |FILB4   =               0    |FILB5    =               0    |
INFO  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX--C--R--O--S--S--XXXXXXXXXX--B--A--R--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|
INFO  TXPDR Slice0 packets     =               0    |TXPDR1  =               0    |TXPDR2  =               0    |TXPDR3  =               0    |TXPDR4  =               0    |TXPDR5   =               0    |
INFO  TXCGM Slice0 packets     =               0    |TXCGM1  =               0    |TXCGM2  =               0    |TXCGM3  =               0    |TXCGM4  =               0    |TXCGM5   =               0    |
INFO  TXCGM Slice0 bytes       =               0    |TXCGM1  =               0    |TXCGM2  =               0    |TXCGM3  =               0    |TXCGM4  =               0    |TXCGM5   =               0    |
INFO  TXCGM Slice0 UC packets  =               0    |TXCGM1  =               0    |TXCGM2  =               0    |TXCGM3  =               0    |TXCGM4  =               0    |TXCGM5   =               0    |
INFO  TXCGM Slice0 MC packets  =               0    |TXCGM1  =               0    |TXCGM2  =               0    |TXCGM3  =               0    |TXCGM4  =               0    |TXCGM5   =               0    |
INFO  SMS IFG0 read packets    =               0    |SMS2    =               0    |SMS4    =               0    |SMS6    =               0    |SMS8    =               0    |SMS 10   =               0    |
INFO  SMS IFG1 read packets    =               0    |SMS3    =               0    |SMS5    =               0    |SMS7    =               0    |SMS9    =               0    |SMS 11   =               0    |
INFO  TXPP0 packets            =               0    |TXPP2   =               0    |TXPP4   =               0    |TXPP6   =               0    |TXPP8   =               0    |TXPP10   =               0    |
INFO  TXPP1 packets            =               0    |TXPP3   =               0    |TXPP5   =               0    |TXPP7   =               0    |TXPP9   =               0    |TXPP11   =               0    |
INFO  IFGB_TX0 packets         =               0    |IFGB2   =               0    |IFGB4   =               0    |IFGB6   =               0    |IFGB8   =               0    |IFGB10   =               0    |
INFO  IFGB_TX1 packets         =               0    |IFGB3   =               0    |IFGB5   =               0    |IFGB7   =               0    |IFGB9   =               0    |IFGB11   =               0    |
INFO  IFG_TX0 good packets     =              21    |IFG_TX2 =              21    |IFG_TX4 =              14    |IFG_TX6 =              21    |IFG_TX8 =              33    |IFG_TX10 =              21    |
INFO  IFG_TX1 good packets     =              21    |IFG_TX3 =              14    |IFG_TX5 =              21    |IFG_TX7 =              14    |IFG_TX9 =              54    |IFG_TX11 =              21    |
INFO  IFG_TX0 good bytes       =            5376    |IFG_TX2 =            5376    |IFG_TX4 =            3584    |IFG_TX6 =            5369    |IFG_TX8 =            5526    |IFG_TX10 =            5348    |
INFO  IFG_TX1 good bytes       =            5376    |IFG_TX3 =            3584    |IFG_TX5 =            5376    |IFG_TX7 =            3570    |IFG_TX9 =            9082    |IFG_TX11 =            5334    |
INFO  (*) = counter overflow

cisco@spine01:~$ 




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


## Ansible stuff
 ansible-playbook -i hosts lab-1-configs.yml -e "ansible_user=cisco ansible_ssh_pass=cisco123 ansible_sudo_pass=cisco123" -vv
 2035  cd ansible
 
## Ansible Issues
["SwSS container is not ready. Retry later or use -f to avoid system checks"]}
