List of ACL types
ACL table details in SWSS
https://github.com/sonic-net/sonic-swss/blob/master/orchagent/acltable.h

SSH ACL v4 and v6
Table types discoverd
- TABLE_TYPE_MIRROR
- TABLE_TYPE_MIRRORV6



     * Type of Tables and Supported Match Types (ASIC database)
     * |------------------------------------------------------------------|
     * |                   | TABLE_MIRROR | TABLE_MIRROR | TABLE_MIRRORV6 |
     * |    Match Type     |----------------------------------------------|
     * |                   |   combined   |          separated            |
     * |------------------------------------------------------------------|
     * | MATCH_SRC_IP      |      √       |      √       |                |
     * | MATCH_DST_IP      |      √       |      √       |                |
     * |------------------------------------------------------------------|
     * | MATCH_ICMP_TYPE   |      √       |      √       |                |
     * | MATCH_ICMP_CODE   |      √       |      √       |                |
     * |------------------------------------------------------------------|
     * | MATCH_SRC_IPV6    |      √       |              |       √        |
     * | MATCH_DST_IPV6    |      √       |              |       √        |
     * |------------------------------------------------------------------|
     * | MATCH_ICMPV6_TYPE |      √       |              |       √        |
     * | MATCH_ICMPV6_CODE |      √       |              |       √        |
     * |------------------------------------------------------------------|
     * | MATCH_IP_PROTOCOL |      √       |      √       |                |
     * | MATCH_NEXT_HEADER |      √       |              |       √        |
     * | -----------------------------------------------------------------|
     * | MATCH_ETHERTYPE   |      √       |      √       |                |
     * |------------------------------------------------------------------|
     * | MATCH_IN_PORTS    |      √       |      √       |                |
     * |------------------------------------------------------------------|
 
     
## configure BFD
1. start bfd daemon
   
2. config frr
```
bfd
 peer 10.1.1.0
 exit
 !
router bgp 65000
 neighbor 10.1.1.0 bfd
 neighbor 10.1.1.6 bfd
```
