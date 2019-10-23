#!/bin/bash

apt-get update
apt-get install software-properties-common -y
apt-add-repository ppa:ansible/ansible -y
apt-get update
apt-get install ansible -y
apt-get install unzip -y

wget https://github.com/sankara7/TFS_Repo/raw/master/Ansible1.zip
unzip Ansible1.zip -d /tmp

cd /tmp/Ansible1

ansible-playbook Play_Apache.yml
