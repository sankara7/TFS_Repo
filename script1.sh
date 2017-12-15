#!/bin/bash

apt-get update
apt-get install software-properties-common
apt-add-repository ppa:ansible/ansible
apt-get update
apt-get install ansible
apt-get install unzip

wget https://github.com/sankara7/TFS_Repo/raw/master/Ansible1.zip
unzip Ansible1.zip -d /tmp

cd /tmp/Ansible1

ansible-playbook Play_Apache.yml
