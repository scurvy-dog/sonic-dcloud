#!/bin/bash

echo "startup script launched at: " > /home/cisco/deploy.log

date >> /home/cisco/deploy.log
whoami >> /home/cisco/deploy.log

ansible-playbook -i /home/cisco/sonic-dcloud/1-SONiC_101/ansible/hosts \
  -e "ansible_user=cisco ansible_ssh_pass=cisco123 ansible_sudo_pass=cisco123" \
  /home/cisco/sonic-dcloud/1-SONiC_101/ansible/dcloud_startup_playbook.yml -v >> /home/cisco/deploy.log


