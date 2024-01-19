#!/bin/bash
# This file is needed to bridge the sudo permission issue with crontab vs ansible

echo "startup script launched at: " > /home/cisco/deploy.log

date >> /home/cisco/deploy.log
whoami >> /home/cisco/deploy.log

ansible-playbook -i /home/cisco/sonic-dcloud/2-SONiC_102/ansible/hosts \
  -e "ansible_user=cisco ansible_ssh_pass=cisco123 ansible_sudo_pass=cisco123" \
  /home/cisco/sonic-dcloud/2-SONiC_102/ansible/dcloud_startup_playbook.yml -v >> /home/cisco/deploy.log


