#!/bin/sh -e

# ensure some sane paths
export PATH="$PATH:/usr/local/bin:/usr/bin:/usr/sbin"

if [ -e /etc/redhat-release ]; then
    if grep -i 'red hat' /etc/redhat-release | grep -i enterprise > /dev/null 2>&1;
    then

    elif grep -i 'centos' /etc/redhat-release >/dev/null 2>&1;
    then
        sudo yum update -y
        sudo yum install epel-release
        sudo yum install -y ansible
    fi
elif type lsb_release >/dev/null 2>&1; then
    lsb_d="$(lsb_release -ds)"
    if echo "$lsb_d" | grep -i ubuntu >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install software-properties-common
        sudo apt-add-repository ppa:ansible/ansible
        sudo apt-get update
        sudo apt-get install ansible
    elif echo "$lsb_d" | grep -i debian >/dev/null 2>&1; then
        echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list
        sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
        sudo apt-get update
        sudo apt-get install ansible
    else
        echo "Unknown Linux Distribution"
        exit 1
    fi
else
    echo "Unknown Linux Distribution"
    exit 1
fi
