#!/bin/sh -e

# ensure some sane paths
export PATH="$PATH:/usr/local/bin:/usr/bin:/usr/sbin"

if [ -e /etc/redhat-release ]; then
    if grep -i 'red hat' /etc/redhat-release | grep -i enterprise > /dev/null 2>&1;
    then
        if [ ! -z "${HTTP_PROXY}" ];
        then
            echo "proxy=${HTTP_PROXY}" >> /etc/yum.conf
        fi
        sudo yum update -y
        sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E '%{rhel}').noarch.rpm
        sudo sed -i "s/mirrorlist=https/mirrorlist=http/" /etc/yum.repos.d/epel.repo
        sudo yum-config-manager --enable rhui-REGION-rhel-server-extras
        sudo yum install -y ansible git
    elif grep -i 'centos' /etc/redhat-release >/dev/null 2>&1;
    then
        if [ ! -z "${HTTP_PROXY}" ];
        then
            echo "proxy=${HTTP_PROXY}" >> /etc/yum.conf
        fi
        sudo yum update -y
        sudo yum install -y epel-release
        sudo sed -i "s/mirrorlist=https/mirrorlist=http/" /etc/yum.repos.d/epel.repo
        sudo yum update -y
        sudo yum install -y ansible git
    fi
elif type lsb_release >/dev/null 2>&1; then
    lsb_d="$(lsb_release -ds)"
    if echo "$lsb_d" | grep -i ubuntu >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install software-properties-common
        sudo apt-add-repository ppa:ansible/ansible
        sudo apt-get update
        sudo apt-get install ansible git
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
