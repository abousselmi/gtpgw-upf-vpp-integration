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
    log "add llb ip address to loopback iface: $LLB_CIDR"
    ip addr add $LLB_CIDR dev lo
}

function delete {
    log "delete loopback config"
    ip addr del $LLB_CIDR dev lo
}

if [ "$1" = "add" ]; then
    add
elif [ "$1" = "delete" ]; then
    delete
else
    echo "Add LLB IP to looback"
    echo ""
    echo "  Usage: $0 <add|delete>"
    echo ""
fi

