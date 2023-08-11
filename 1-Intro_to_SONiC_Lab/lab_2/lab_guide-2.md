# Lab 2 Guide: SONiC Topology Setup and Validation [40 Min]
This dCloud lab makes heavy use of the relatively new Dockerized Cisco 8000 emulator router known. If you wish to explore Cisco 8000 emulator and its uses beyond the scope of this lab the document team has posted an installation guide here: https://www.cisco.com/c/en/us/support/routers/8000-series-virtual-router-emulator/series.html

### Description: 
In Lab 1 the student will launch the SONiC topology and validate it is up and running. This will be the baseline 
topology all subsequent lab exercises. Second, they will validate that the pre-configured ISIS and BGP routing protocols are running and seeing the correct topology. 

## Contents
  - [Tour of SONiC](#tour-of-sonic)
     - [SONiC Software Architecture](#sonic-software-architecture)
     - [Health Check of SONiC Components](#health-check-of-sonic-components)
     - [Tour of SONiC CLI](#tour-of-sonic-cli)
     - [Managing Configs](#managing-configs)
  - [Ansible Automation](#ansible-automation)
     - [Ansible Playbook Overview](#ansible-playbook-overview)
     - [Review Playboook Results](#review-playbook-results)
  - [Validate Lab Topology](#validate-lab-topology)
  - [End of Lab 2](#end-of-lab-2)
  
## Lab Objectives
The student upon completion of Lab 1 should have achieved the following objectives:

* Access to all devices in the lab
* Deployed the XRd network topology
* Understanding of the lab topology and components
* Confirm IPv4 and IPv6 connectivity   


## Validate Device Access

Device access 
