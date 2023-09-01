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

## ACL Table Scheme

Table Type Scheme

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


## Basic ACL Walk Through


## ACL Configuration Syntax

## ACL Scale

## ACL Troubleshooting


## End of Lab 4
Please proceed to [Lab 5](https://github.com/scurvy-dog/sonic-dcloud/blob/main/1-Intro_to_SONiC_Lab/lab_5/lab_5-guide.md)
