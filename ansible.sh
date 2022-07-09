#!bin/bash

sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
sudo dnf install epel-release -y
sudo dnf install ansible -y

mkdir ~/ansible
cd ~/ansible

python3 /tmp/hosts.py

