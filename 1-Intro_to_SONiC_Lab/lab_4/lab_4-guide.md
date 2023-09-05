# Lab 4 Guide: ACL Overview and Config [30 Min]


### Description: 
In Lab 4 the student will explore how SONiC utilizes ACLs in dataplane and controlplane application. An overview of where and how SONiC applies ACLs will be provided and configuration examples.

## Contents
- [Lab 4 Guide: Configure BGP \[40 Min\]](#lab-4-guide:-acl-overview-and-config-30-min)
    - [Description:](#description)
    - [SONiC ACL Architecture](#sonic-acl-architecture)
      - [Data Plane ACL]
      - [Control Plane ACL]
      - [Mirror/Span/Everflow ACL]
    - [Basic ACL Walkthrough](#basic-acl-walk-through)
        - [Create ACL Table](#create-acl-table)
        - [Create ACL Rules](#create-acl-rules)
        - [Apply ACL and Test](#apply-acl-and-test)
    - [ACL Configuration Syntax](#acl-configuration-syntax)
      - [ACL Table Syntax](#acl-table-syntax)
      - [ACL Rule Syntax](#acl-rule-syntax)
      - [CRUD Operations]
    - [ACL Scale](#acl-scale)
    - [ACL Troubleshooting](#acl-troubleshooting)
      - [Testing scenarios]
    - [ACL Config Appendix]
  - [End of Lab 4](#end-of-lab-4)
  
## Lab Objectives
The student upon completion of Lab 4 should have achieved the following objectives:

* Understand types of ACLs SONiC Supports
* Basic ACL syntax construction
* Ability to apply ACLs in SONiC

## SONiC ACL Architecture

### ACL Table Definition Types


| Type                | Description                       | Ingress | Egress  | 
|:--------------------|:----------------------------------|:-------:|:-------:|
| L3                  | Match on IPv4 ACL                 | X       | X       |
| L3V6                | Match on IPv6 ACL                 | X       | X       |
| L3V4V6              | Match on IPv4 and v6 combined ACL | X       | X       |
| MIRROR              | Match on IPv4 ACL to mirror flow  | X       | X       |
| MIRRORV6            | Match on IPv6 ACL to mirror flow  | X       | X       |
| MIRROR_DSCP         | Match on DSCP ACL to mirror flow  | X       | X       |
| PFCWD               | Research                          | X       | X       |
| MLAG                | Research                          | X       | X       |
| MUX                 | Research                          | X       | X       |
| DROP                | Research                          | X       | X       |
| CTRLPLANE           | Research                          | X       | X       |
| DTEL_FLOW_WATCHLIST | Research                          | X       | X       |

### ACL Match Options

For reference on IPv4 Packet Header see this link [HERE](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#Header)
For reference on IPv4 Packet Header see this link [HERE](https://en.wikipedia.org/wiki/IPv6#IPv6_packets)

| Type                     | Description                                | Notes              | 
|:-------------------------|:-------------------------------------------|:-------------------|
| MATCH_IN_PORTS           | Match Ingress Port                         |                    |
| MATCH_OUT_PORTS          | Match Egress Port                          |                    |
| MATCH_SRC_IP             | Match Source IPv4 Address                  |                    |
| MATCH_DST_IP             | Match Destination IPv4 Address             |                    |
| MATCH_SRC_IPV6           | Match Source IPv6 Address                  |                    |
| MATCH_DST_IPV6           | Match Destination IPv6 Address             |                    |
| MATCH_L4_SRC_PORT        | Match Source Layer 4 Port                  |                    |
| MATCH_L4_DST_PORT        | Match Destination Layer 4 Port             |                    |
| MATCH_L4_SRC_PORT_RANGE  | Match Source Layer 4 Port Range            |                    |
| MATCH_L4_DST_PORT_RANGE  | Match Destination Layer 4 Port Range       |                    |
| MATCH_ETHER_TYPE         | Match Ethernet Type Field                  |                    |
| MATCH_VLAN_ID            | Match VLAN ID                              |                    |
| MATCH_IP_PROTOCOL        | Match IP Protocol Number                   | In IPv4 / IPv6 Header |
| MATCH_NEXT_HEADER        | Match IPv6 Next Header                     | Needs Research        |
| MATCH_TCP_FLAGS          | Match TCP Flags Field                      |                    |
| MATCH_IP_TYPE            | Match IP                  |                    |
| MATCH_ETHER_TYPE         | Match Ethernet Type Field                  |                    |




    { MATCH_IP_TYPE,           SAI_ACL_ENTRY_ATTR_FIELD_ACL_IP_TYPE },
    { MATCH_DSCP,              SAI_ACL_ENTRY_ATTR_FIELD_DSCP },
    { MATCH_TC,                SAI_ACL_ENTRY_ATTR_FIELD_TC },
    { MATCH_ICMP_TYPE,         SAI_ACL_ENTRY_ATTR_FIELD_ICMP_TYPE },
    { MATCH_ICMP_CODE,         SAI_ACL_ENTRY_ATTR_FIELD_ICMP_CODE },
    { MATCH_ICMPV6_TYPE,       SAI_ACL_ENTRY_ATTR_FIELD_ICMPV6_TYPE },
    { MATCH_ICMPV6_CODE,       SAI_ACL_ENTRY_ATTR_FIELD_ICMPV6_CODE },
    { MATCH_TUNNEL_VNI,        SAI_ACL_ENTRY_ATTR_FIELD_TUNNEL_VNI },
    { MATCH_INNER_ETHER_TYPE,  SAI_ACL_ENTRY_ATTR_FIELD_INNER_ETHER_TYPE },
    { MATCH_INNER_IP_PROTOCOL, SAI_ACL_ENTRY_ATTR_FIELD_INNER_IP_PROTOCOL },
    { MATCH_INNER_L4_SRC_PORT, SAI_ACL_ENTRY_ATTR_FIELD_INNER_L4_SRC_PORT },
    { MATCH_INNER_L4_DST_PORT, SAI_ACL_ENTRY_ATTR_FIELD_INNER_L4_DST_PORT },
    { MATCH_BTH_OPCODE,        SAI_ACL_ENTRY_ATTR_FIELD_BTH_OPCODE},
    { MATCH_AETH_SYNDROME,     SAI_ACL_ENTRY_ATTR_FIELD_AETH_SYNDROME}

## Basic ACL Walk Through


## ACL Configuration Syntax

## ACL Scale

## ACL Troubleshooting


## End of Lab 4
Please proceed to [Lab 5](https://github.com/scurvy-dog/sonic-dcloud/blob/main/1-Intro_to_SONiC_Lab/lab_5/lab_5-guide.md)
