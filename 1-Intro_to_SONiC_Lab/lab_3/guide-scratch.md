## Validate Lab Topology
### Validate Client VMs

__Endpoint-1__

In our lab the Rome VM represents a standard linux host or endpoint, and is essentially a customer/user of our network.

1. SSH to Endpoint-1 Client VM from your laptop.
   ```
   ssh cisco@198.18.128.103
   ```

__Endpoint-2__

The Endpiont-2 VM represents a VM belonging in another virtual network (different then Endpoint-1 VM). The Endpoint-1 VM comes with 

1. SSH to Endpoint-2 Client VM from your laptop.
   ```
   ssh cisco@198.18.128.102
   ```

### lab 3 playbook
configures FRR BGP on spin01, spine02, and leaf02

```
ansible-playbook -i hosts lab_2-playbook.yml -e "ansible_user=cisco ansible_ssh_pass=cisco123 ansible_sudo_pass=cisco123" -vv
```

