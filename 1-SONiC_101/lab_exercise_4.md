# Lab Exercise 4: ACL Overview and Config [30 Min]


### Description: 
In Lab Exercise 4 the student will explore how SONiC utilizes ACLs in data-plane and control plane application. An overview of where and how SONiC applies ACLs will be provided and configuration examples.

## Contents
- [Lab Exercise 4: ACL Overview and Config \[30 Min\]](#lab-exercise-4-acl-overview-and-config-30-min)
    - [Description:](#description)
  - [Contents](#contents)
  - [Lab Objectives](#lab-objectives)
  - [SONiC ACL Architecture](#sonic-acl-architecture)
  - [ACL Tables](#acl-tables)
    - [ACL Table Parameters](#acl-table-parameters)
    - [ACL Table Syntax](#acl-table-syntax)
    - [ACL Table Add](#acl-tables-add)
    - [ACL Table Delete](#acl-table-delete)
  - [ACL Rules](#acl-rules)
    - [ACL Rule parameters](#acl-rule-parameters)
    - [ACL Rule Syntax](#acl-rule-syntax)
    - [ACL Rule Add](#acl-rules-add)
    - [ACL Rule Delete](#acl-rules-delete)
  - [ACL Examples](#acl-examples)
  - [End of Lab 4](#end-of-lab-4)
  
## Lab Objectives
The student upon completion of Lab Exercise 4 should have achieved the following objectives:

* Understand types of ACLs SONiC Supports
* Basic ACL syntax construction
* Ability to apply ACLs in SONiC

## SONiC ACL Architecture
The core of ACLs in SONiC is the ACL Table which links interface(s) with rule sets and defines the direction of the policy enforcement. See the diagram below to see the relationship.

![ACL Overview](./topo-drawings/acl-overview.png)

ACLs can be grouped into three general categories:
    1. Data-plane ACLs applied against physical interfaces
    2. Control plane ACLs
    3. Mirror ACLs for capturing and replicating traffic
In this lab we will focus on the first type - Data-plane ACLs.

## ACL Tables
In this lab we are focusing specifically on data-plane ACLs. The purpose of data-plane ACL tables is to link a set of rules that can be applied to data-plane traffic to a group of defined interfaces. 

ACL tables can be created or deleted using either CLI or through a JSON definition which is loaded into the running config. We will show both options in this lab. 

### ACL Table Parameters
Data-plane ACL Tables have mandatory and optional defined fields as listed in the below table.

| Parameters | CLI Flag | Mandatory | Details                                          |
|:-----------|:--------:|:---------:|:-------------------------------------------------|
| table name | none     | X         | The name of the ACL table to create.             |
| table type | none     | X         | Type of ACL table to create. *See table above*   |
| description| -d       |           | Table description. Defaults to table name        |
| ports      | -p       |           | Binds table to physical port,portchannel, VLAN   |
| stage      | -s       |           | Valid options are ingress (default) or egress    |


**Table Type Field Definitions**
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

### ACL Table Syntax

In this example set of code we want to set the following parameters through CLI or JSON.
- Name the ACL Table: ICMP_DROP
- Traffic Type Affected: IPv4 Layer 3 packets
- Interface Bindings: Ethernet 32
- Traffic Direction: Ingress
    
#### ACL Table Add
**Adding ACL Table with CLI**
```
cisco@leaf-2:~$ sudo config acl add table --help
Usage: config acl add table [OPTIONS] <table_name> <table_type>
  Add ACL table

Options:
  -d, --description TEXT
  -p, --ports TEXT
  -s, --stage [ingress|egress]
```
We will now add in an ACL table using the above parameters using the CLI below.
  ```
  sudo config acl add table ICMP_DROP L3 -p Ethernet32 -d "BLock ICMP traffic from Endpoint2" -s ingress
  ```
  ```
  cisco@leaf-2:~$ sudo acl-loader show table
  Name       Type    Binding     Description                        Stage    Status
  ---------  ------  ----------  ---------------------------------  -------  --------
  ICMP_DROP  L3      Ethernet32  BLock ICMP traffic from Endpoint2  ingress  Active
  ```

**Adding ACL Table through JSON**
To utilize JSON to create an ACL it is a two step process. First you must construct a valid JSON syntax file and store that on the SONiC router itself. The second step is to use the config load command to add the table into the running configuration. See steps below.

**Example of ACL Table JSON**
Save this json acl table definition to a file on the SONiC device as acl_table_icmp.json

```
{
"ACL_TABLE": {
            "ICMP_DROP": {
                    "policy_desc" : "Block IMCP traffic from endpoint 2",
                    "type" : "L3",
                    "stage": "ingress",
                    "ports" : [
                        "Ethernet32"
                    ] 
                    }
        }
}
```
- **Loading the ACL table JSON file into the running config**
  ```
  sudo config load acl_table_icmp.json
  ```

### ACL Table Delete
Through CLI you an leverage the *sudo config acl remove* command as seen below

```
sudo config acl remove table ICMP_DROP
```

## ACL Rules
ACL Rules contain the detail step by step policy that is implemented by the tables. ACL Rule structure will identify which ACL Table they should be joined to. ACL Rules can only be defined using JSON and have no CLI option. We will show a basic ACL Rule used to block ICMP traffic coming from Endpoint-2 to *Loopback 0* on Leaf-2

### ACL Rule Parameters
ACL rule sets have a much larger parameter set than tables due to the complex nature of the ACL match option combinations. There are over 30 plus parameters list in the table below. In this lab we will use 2-3 as examples.

- For reference on Ethernet Header see this link [HERE](https://en.wikipedia.org/wiki/Ethernet_frame)
- For reference on IPv4 Packet Header see this link [HERE](https://en.wikipedia.org/wiki/Internet_Protocol_version_4#Header)
- For reference on IPv6 Packet Header see this link [HERE](https://en.wikipedia.org/wiki/IPv6#IPv6_packets)
- For reference on ICMP Packet Header see this link [HERE](https://en.wikipedia.org/wiki/Ping_(networking_utility)#ICMP_packet)
- For referenec on VXLAN Packet Header see this link [HERE](https://learningnetwork.cisco.com/s/blogs/a0D3i000005YebJEAS/introduction-to-vxlan)

**Match Table Parameters**

| Type               | Description                                | Notes                                          | 
|:-------------------|:-------------------------------------------|:-----------------------------------------------|
| IN_PORTS           | Match Ingress Port                         |                                                |
| OUT_PORTS          | Match Egress Port                          |                                                |
| SRC_IP             | Match Source IPv4 Address                  | A valid IPv4 subnet in format IP/Mask          |
| DST_IP             | Match Destination IPv4 Address             | A valid IPv4 subnet in format IP/Mask          |
| SRC_IPV6           | Match Source IPv6 Address                  | A valid IPv6 subnet in format IP/Mask          |
| DST_IPV6           | Match Destination IPv6 Address             | A valid IPv6 subnet in format IP/Mask          |
| L4_SRC_PORT        | Match Source Layer 4 Port                  | Decimal integer [0..65535]                     |
| L4_DST_PORT        | Match Destination Layer 4 Port             | Decimal integer [0..65535]                     |
| L4_SRC_PORT_RANGE  | Match Source Layer 4 Port Range            | Two dash separated decimal integers [0..65535] |
| L4_DST_PORT_RANGE  | Match Destination Layer 4 Port Range       | Two dash separated decimal integers [0..65535] |
| ETHER_TYPE         | Match Ethernet Type Field                  |                                                |
| VLAN_ID            | Match VLAN ID                              |                                                |
| IP_PROTOCOL        | Match IP Protocol Number                   | Hexadecimal unsigned integer [0..FF]           |
| NEXT_HEADER        | Match IPv6 Next Header Field               |                                                |
| TCP_FLAGS          | Match TCP Flags Field                      | Hexadecimal unsigned integer [0..FF]           |
| IP_TYPE            | Match IPv4 Options Type Field              | String of one type of: "IPv4"/"NON_IPv4"/"ARP" |
| ETHER_TYPE         | Match Ethernet Type Field                  |                                                |
| DSCP               | Match IPv4 Header DSCP Field               | DSCP (6b)                                      |
| TC                 | Match IPv6 Header Traffic Class Field      | DSCP(6b) + ECN(2b)                             |
| ICMP_TYPE          | Match ICMPv4 ICMP Type Field               |                                                |
| ICMP_CODE          | Match ICMPv4 ICMP Code Field               |                                                |
| ICMPV6_TYPE        | Match ICMPv6 Type Field                    |                                                |
| ICMPV6_CODE        | Match ICMPv6 Options Field                 |                                                |
| TUNNEL_VNI         | Match VXLAN VNID Field                     | VNI (24b)                                      |
| INNER_ETHER_TYPE   | Match Inner Header Ethernet Type Field     | Research                                       |
| INNER_IP_PROTOCOL  | Match Inner Header IP Protocol Number      | Research                                       |
| INNER_L4_SRC_PORT  | Match Inner Header Source Layer 4 Port     | Research                                       |
| INNER_L4_DST_PORT  | Match Inner Header Destination Layer 4 Port| Research                                       |
| BTH_OPCODE         | Match ???                                  | Research                                       |
| AETH_SYNDROME      | Match ???                                  | Research                                       |


### ACL Rule Syntax
ACL rules are defined using the JSON syntax for purposes of importing into the runnging configuration (redis database). The syntax follows a strict heirarchy of objects and then defining key:value pairs. 

The top level of the heirarchy is defined by the "ACL_RULE" object. Within the objects that data set are individual rules.
Individual rules follows the below syntax
```
    "<ACL TABLE NAME>|<ACL RULE NAME>":{
        "<KEY VALUE>": "<KEY VALUE>",
        "<KEY VALUE>": "<KEY VALUE>"
    }
```
Each ACL rule for data-plane ACL rule requires two key values: *PACKET_ACTION* and *PRIORITY*. 
The remaining <key>:<value> pairs would be matching conditions found in the above table labled *Match Table Parameters*.

If the ACL Table type is *L3* or *L3V6* then the ACL rule *PACKET_ACTION* valid options are {FORWARD | DROP}

The *PRIORITY* value is processed by **highest numerical value first**. So in the below rule set RULE_20 with *PRIORITY 20* will be processed before RULE_10 *PRIORITY 10*.

### ACL Rule Add
**Example JSON file that should be saved as acl_rule_icmp.json** 

```
{
    "ACL_RULE": {
        "ICMP_INGRESS|RULE_10": {
            "PACKET_ACTION": "FORWARD",
            "PRIORITY": "10",
            "SRC_IP": "198.18.12.1/32"
        },
        "ICMP_INGRESS|RULE_20": {
            "PACKET_ACTION": "DROP",
            "PRIORITY": "20",
            "SRC_IP": "10.0.0.2/32"
        }
    }
}
```

**Loading the ACL rule JSON file into the running config**
```
sudo config load acl_rule_icmp.json
```

### ACL Rule Delete
> **NOTE**
> SONiC does not support the removal of ACLs through CLI. The below json will remove all ACL rules

The below json will remove **ALL** ACL rule sets in the running configuration. Save the JSON into a file called acl-wipe.json
  
```
{
    "acl": {
        "acl-sets": {
            "acl-set": {
            }
        }
    }
}
```

Apply the command using the below.
```
sudo config acl update full acl-wipe.json
```

## ACL Examples
Below are two basic ACLs to show how to apply and check ACL effectivness 

### ACL Example - Block ICMP to Loopback
In this example we will block ICMP traffic destined to from *endpoint-1* to *loopback 0* on *leaf-1*
We will need to apply the ACL to the *Ethernet 32* interface of *leaf-1*
Lets create an ACL Table that we will link to the interface

1. First login to SONiC Router *leaf-1*
2. In the home directory lets create a json definition file for the ACL Table
   ```
   nano eth32_acl_table.json
   ```
3. Paste in the following code and save and exit.
   ```
   {
   "ACL_TABLE": {
            "ICMP_DROP": {
                    "policy_desc" : "Block IMCP traffic from endpoint 1",
                    "type" : "L3",
                    "stage": "ingress",
                    "ports" : [
                        "Ethernet32"
                    ] 
                    }
        }
   }
   ```
4. Load the json definition file into the running config
   ```
   sudo config load eth32_acl_table.json
   ```
5. Verify the ACL table was installed.
   ```
   cisco@leaf-1:~$ show acl table
   Name       Type    Binding     Description                         Stage    Status
   ---------  ------  ----------  ----------------------------------  -------  --------
   ICMP_DROP  L3      Ethernet32  Block IMCP traffic from endpoint 1  ingress  Active
   ```
6. In the home directory lets create a json definition file for the ACL Rule Set
   ```
   nano acl_ep1_ingress.json
   ```
7. Paste in the following code and save and exit.
   ```
  {
    "ACL_RULE": {
        "ICMP_DROP|RULE_10": {
            "PACKET_ACTION": "FORWARD",
            "PRIORITY": "10",
            "SRC_IP": "198.18.11.2/32"
        },
        "ICMP_DROP|RULE_20": {
            "PACKET_ACTION": "DROP",
            "PRIORITY": "20",
            "SRC_IP": "198.18.11.2/32",
            "IP_PROTOCOL":1
        }
    }
}    
   ```

8. Verify the ACL rule set was installed
   ```
   cisco@leaf-1:~$ sudo config load acl_ep1_ingress.json
   Load config from the file(s) acl_ep1_ingress.json ? [y/N]: y
   Running command: /usr/local/bin/sonic-cfggen -j acl_ep1_ingress.json --write-to-db
   cisco@leaf-1:~$ show acl rule
   Table      Rule     Priority    Action    Match                   Status
   ---------  -------  ----------  --------  ----------------------  --------
   ICMP_DROP  RULE_20  20          FORWARD   SRC_IP: 198.18.12.2/32  Active
   ICMP_DROP  RULE_10  10          DROP      IP_PROTOCOL: 1          Active  
                                             SRC_IP: 198.18.12.2/32
   ```

## Scratch
aclshow -a
sonic-clear acl

## End of Lab 4
Please proceed to [Lab 5](https://github.com/scurvy-dog/sonic-dcloud/edit/main/1-SONiC_101/lab_exercise_5.md)
