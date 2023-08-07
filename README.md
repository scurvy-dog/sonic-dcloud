### SONiC dcloud

For info on launching SONiC VXR with containerlab please refer to https://github.com/brmcdoug/containerlab/tree/main/vxrSONiC

SONiC can be configured one of three ways:
1. /etc/sonic/config_db.json 
   [config_db](/config_guide-config_db.md)
   
2. Linux [CLI](/config_guide-CLI.md)
   - not all features are supported from the Linux CLI
3. FRR [CLI](/config_guide-CLI.md)
   - FRR configs are not persistent across reboots unless you modify /etc/sonic/config_db.json 
>[!NOTE]
>This page needs significant work
