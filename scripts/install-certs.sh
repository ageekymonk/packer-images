#!/bin/sh -e

CERTS_DIR=$1

# ensure some sane paths
export PATH="$PATH:/usr/local/bin:/usr/bin:/usr/sbin"

if [ -e /etc/redhat-release ]; then
    if grep -i 'red hat' /etc/redhat-release | grep -i enterprise > /dev/null 2>&1;
    then
        cp ${CERTS_DIR}/*.cer /etc/pki/ca-trust/source/anchors/
        sudo update-ca-trust extract
    elif grep -i 'centos' /etc/redhat-release >/dev/null 2>&1;
    then
        cp ${CERTS_DIR}/*.cer /etc/pki/ca-trust/source/anchors/
        sudo update-ca-trust extract
    fi
elif type lsb_release >/dev/null 2>&1; then
    lsb_d="$(lsb_release -ds)"
    if echo "$lsb_d" | grep -i ubuntu >/dev/null 2>&1; then
        echo "TODO: Install Certs"
    elif echo "$lsb_d" | grep -i debian >/dev/null 2>&1; then
        echo "TODO: Install Certs"
    else
        echo "Unknown Linux Distribution"
        exit 1
    fi
else
    echo "Unknown Linux Distribution"
    exit 1
fi
