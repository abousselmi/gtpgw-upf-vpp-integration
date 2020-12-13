#!/bin/bash

# author: abousselmi

set -e

if [ "$EUID" -ne 0 ] ; then
    echo "Please run as root"
    exit 1
fi

## Configuration
source ./env-config.sh

## Logger
function log {
    echo -e "$(date +%F-%T) | $(hostname) | INFO | $1"
}

function add {
    log "add route to UE ($UE_CIDR) via n6-sec ($UPF_N62_HOST_IP)"
    ip route add $UE_CIDR via $UPF_N62_HOST_IP
}

function delete {
    log "delete UE route via n6-sec ($UPF_N62_HOST_IP)"
    ip route del $UE_CIDR via $UPF_N62_HOST_IP
}

if [ "$1" = "add" ]; then
    add
elif [ "$1" = "del" ]; then
    delete
else
    echo "Add/delete UE route via N6"
    echo ""
    echo "  Usage: $0 <add|del>"
    echo ""
fi

