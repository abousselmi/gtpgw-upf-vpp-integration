#!/bin/bash

# author: abousselmi

set -e

if [ "$EUID" -ne 0 ] ; then
    echo "Please run as root"
    exit 1
fi

## Configuration
source ./0001-env-config.sh

## Logger
function log {
    echo -e "$(date +%F-%T) | $(hostname) | INFO | $1"
}

function add {
    log "add ue route via n6"
    ip route add $UE_CIDR via $UPF_N61_HOST_IP
    log "done"
}

function delete {
    log "delete ue route via n6"
    ip route add $UE_CIDR via $UPF_N61_HOST_IP
    log "done"
}

if [ "$1" = "add" ]; then
    add
elif [ "$1" = "delete" ]; then
    delete
else
    echo "Add/delete UE route via N6"
    echo ""
    echo "  Usage: $0 <add|delete>"
    echo ""
fi

