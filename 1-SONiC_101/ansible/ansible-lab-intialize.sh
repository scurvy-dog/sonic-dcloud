#!/bin/bash

echo "startup script launched at: " > /home/cisco/.startup.log

date >> /home/cisco/.startup.log
whoami >> /home/cisco/.startup.log

ansible-playbook -i /home/cisco/sonic-dcloud/1-SONiC_101/ansible/hosts -e "ansible_user=cisco ansible_ssh_pass=cisco123 ansible_sudo_pass=cisco123" /home/cisco/sonic-dcloud/1-SONiC_101/ansible/dcloud_startup_playbook.yml -v >> /home/cisco/.startup.log

sleep 5

ansible-playbook -e "ansible_user=cisco ansible_ssh_pass=cisco123 ansible_sudo_pass=cisco123" /home/cisco/sonic-dcloud/1-SONiC_101/ansible/sonic_node_health_check.yml -v >> /home/cisco/.startup.log

echo "starting ansible health check playbook"
