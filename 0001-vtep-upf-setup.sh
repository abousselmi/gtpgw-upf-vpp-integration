#!/bin/bash

# author: abousselmi

set -e

if [ "$EUID" -ne 0 ] ; then
    echo "Please run as root"
    exit 1
fi

source ./0001-env-config.sh

function log {
    echo -e "$(date +%F-%T) | $(hostname) | INFO | $1"
}

function print_test {
    echo ""
    echo "You can test using:"
    echo "    ping -c4 $GTPGW_VTEP_IP"
    echo ""
}

function upf_endpoint_up {
    log "create the vxlan device"
    ip link add $UPF_VTEP_DEV type vxlan id 42 dev $GTPGW_DEV dstport 4789

    log "update forwarding table"
    bridge fdb append to 00:00:00:00:00:00 dst $GTPGW_IP dev $UPF_VTEP_DEV

    log "configure ip address on the device"
    ip addr add $UPF_VTEP_CIDR dev $UPF_VTEP_DEV

    log "set the vxlan device UP"
    ip link set up dev $UPF_VTEP_DEV

    log "done"

    print_test
}

function upf_endpoint_down {
    log "cleanup start"

    log "set vxlan device DOWN"
    ip link set down dev $UPF_VTEP_DEV

    log "delete vxlan device"
    ip link del $UPF_VTEP_DEV

    log "cleanup finished"
}

if [ "$1" = "add" ]; then
    upf_endpoint_up
elif [ "$1" = "delete" ]; then
    upf_endpoint_down
else
    echo "This creates a vxlan endpoint on upf side"
    echo ""
    echo "  Usage: $0 <add|delete>"
    echo ""
fi

