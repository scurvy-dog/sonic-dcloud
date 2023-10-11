### SONiC dCloud CLI config guide

#### Linux CLI
Good for setting hostname and interface configs. Example:

```
sudo config hostname router-2
sudo config interface ip add Ethernet0 10.1.1.1/31
sudo config interface ip add Ethernet0 fc00:0::1/127
sudo config interface ip add Ethernet4 10.1.1.4/31
sudo config interface ip add Ethernet4 fc00:0::4/127
sudo config save
```

#### FRR CLI
FRR command line looks and feels a lot like classic IOS

1. invoke FRR command line from sonic linux:
```
vtysh
```
Example:
```
cisco@sonic:~$ vtysh

Hello, this is FRRouting (version 8.2.2).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

sonic# 
```
2. Invoke config mode, then paste in some config:
```
config

hostname router-3
!
interface lo0
 ip address 10.0.0.3/32
 ipv6 address fc00:0:3::1/128
exit
!
interface Ethernet0
 ip address 10.1.1.3/31
 ipv6 address fc00::3/127
exit
!
interface Ethernet4
 ip address 10.1.1.5/31
 ipv6 address fc00::5/127
exit
```

3. BGP config:
```
router bgp 65000
 neighbor 10.1.1.2 remote-as 65001
 neighbor 10.1.1.4 remote-as 65002
 neighbor fc00::2 remote-as 65001
 neighbor fc00::4 remote-as 65002
 !
 address-family ipv4 unicast
  network 10.0.0.3/32
 exit-address-family
 !
 address-family ipv6 unicast
  network fc00:0:3::1/128
  neighbor fc00::2 activate
  neighbor fc00::4 activate
 exit-address-family
exit
```

#### Notes on FRR config
1. sonic does not appear to adopt FRR hostname
2. 

