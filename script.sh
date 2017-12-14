#!/bin/bash

# Disable the need for a tty when running sudo and allow passwordless sudo for the admin user

sed -i '/Defaults[[:space:]]\+!*requiretty/s/^/#/' /etc/sudoers
echo "$ADMIN_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh epel-release-latest-7.noarch.rpm


sudo yum install ansible -y

wget https://github.com/sankara7/TFS_Repo/raw/master/Ansible.zip
unzip Ansible.zip -d /tmp

cd /tmp/Ansible

ansible-playbook Play_Apache.yml
