#!/bin/bash

# author: abousselmi

set -e

if [ "$EUID" -ne 0 ] ; then
    echo "Please run as root"
    exit 1
fi

## Configuration (RAN N3 endpoint emulator)
source ./env-config.sh

function log {
    echo -e "$(date +%F-%T) | $(hostname) | INFO | $1"
}

function add {
    log "add ue ip to loopback iface: $UE_CIDR"
    ip addr add $UE_CIDR dev lo
}

function delete {
    log "delete loopback config"
    ip addr del $UE_CIDR dev lo
}

if [ "$1" = "add" ]; then
    add
elif [ "$1" = "del" ]; then
    delete
else
    echo "Add UE IP address to loopback"
    echo ""
    echo "  Usage: $0 <add|del>"
    echo ""
fi

