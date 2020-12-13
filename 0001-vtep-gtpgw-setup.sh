#!/bin/bash

# author: abousselmi

set -e

if [ "$EUID" -ne 0 ] ; then
    echo "Please run as root"
    exit 1
fi

source ./env-config.sh

function log {
    echo -e "$(date +%F-%T) | $(hostname) | INFO | $1"
}

function print_test {
    echo ""
    echo "You can test using:"
    echo "    ping -c4 $UPF_VTEP_IP"
    echo "    ping -c4 $UPF_N3_VETH_IP"
    echo ""
}

function gtpgw_endpoint_up {
    log "create the vxlan device ($GTPGW_VTEP_DEV)"
    ip link add $GTPGW_VTEP_DEV type vxlan id 42 dev $GTPGW_DEV dstport 4789

    log "update forwarding table"
    bridge fdb append to 00:00:00:00:00:00 dst $UPF_IP dev $GTPGW_VTEP_DEV

    log "add ip address ($GTPGW_VTEP_CIDR) to device ($GTPGW_VTEP_DEV)"
    ip addr add $GTPGW_VTEP_CIDR dev $GTPGW_VTEP_DEV

    log "set the vxlan device ($GTPGW_VTEP_DEV) UP"
    ip link set up dev $GTPGW_VTEP_DEV

    log "add route to n3 ($UPF_N3_HOST_IP) via n3-veth ($UPF_N3_VETH_IP)"
    ip route add $UPF_N3_HOST_IP via $UPF_N3_VETH_IP dev $GTPGW_VTEP_DEV

    log "done"

    print_test
}

function gtpgw_endpoint_down {
    log "cleanup start"

    log "delete n3 route"
    ip route del $UPF_N3_HOST_IP via $UPF_N3_VETH_IP dev $GTPGW_VTEP_DEV

    log "set vxlan device ($GTPGW_VTEP_DEV) DOWN"
    ip link set down dev $GTPGW_VTEP_DEV

    log "delete vxlan device ($GTPGW_VTEP_DEV)"
    ip link del $GTPGW_VTEP_DEV

    log "cleanup finished"
}

if [ "$1" = "add" ]; then
    gtpgw_endpoint_up
elif [ "$1" = "del" ]; then
    gtpgw_endpoint_down
else
    echo "This creates a vxlan endpoint on gtp-gw side"
    echo ""
    echo "  Usage: $0 <add|del>"
    echo ""
fi

