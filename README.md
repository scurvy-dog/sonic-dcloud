# Welcome to the SONiC Labs on Cisco dCloud

### Description: This repository contains lab guide, router configs, setup scripts, and other code for running through the various SONiC labs.

SONiC is an open source network operating system based on Linux that runs on switches/routers from multiple vendors and ASICs. SONiC offers a full-suite of network functionality, like BGP, that has been production-hardened in the data centers of some of the largest cloud-service providers. That said, of this writing (October 2023) SONiC may not be the best choice for all network operators. One of the purposes of this lab series is to give network engineers and operators hands on exposure to SONiC so they may get a sense for what's available today, and what challenges they might face should they pursue a real SONiC deployment.

Though it is easy to run SONiC in a virtualized lab environment, this lab brings the ability to run SONiC on a platform that emulates the Cisco 8000 hardware. This allows us to test data-plane features such as ACLs, hardware counters, and debug tools. 

The lab software stack is built off the SONiC master build with Cisco specific platform drivers for the Cisco 8000 hardware.

## Contents
* Overview of Cisco dCloud [LINK](#cisco-dcloud-overview)
* SONiC 101 - Introduction to SONiC on Cisco 8000 [LINK](/1-SONiC_101/readme.md)
* SONiC 102 - Future: SRv6 SONiC on Cisco 8000 [LINK](/4-SRv6_Lab/readme.md)


## Cisco dCloud Overview
dCloud is Cisco's cloud based demo platform that showcases a large catalog of demos, training and sandboxes for every Cisco architecture. This is the chosen platform to demonstrate our SONiC labs as they will be available through Cisco's global DC infrastructure.

For each lab within this repository you will find a corresponding lab in dCloud. You will need a dCloud account in order to access these labs. You can login to dCloud at https://dcloud.cisco.com

Once you have scheduled a lab in dCloud Cisco AnyConnect VPN connection information will be provided for the lab instance. Once the dCloud session is deployed, all lab guides, configs, diagrams, and code are here in this github repository.
