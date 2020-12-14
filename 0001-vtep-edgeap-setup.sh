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
    echo "    ping -c4 $GTPGW_VTEP_IP"
    echo ""
}

function ap_endpoint_up {
    log "create the vxlan device ($AP_VTEP_DEV)"
    ip link add $AP_VTEP_DEV type vxlan id 42 dev $AP_DEV dstport 4789

    log "update forwarding table"
    bridge fdb append to 00:00:00:00:00:00 dst $GTPGW_IP dev $AP_VTEP_DEV

    log "add ip address ($AP_VTEP_CIDR) to device ($AP_VTEP_DEV)"
    ip addr add $AP_VTEP_CIDR dev $AP_VTEP_DEV

    log "set the vxlan device ($AP_VTEP_DEV) UP"
    ip link set up dev $AP_VTEP_DEV

    log "add route to LLB IP ($LLB_IP) via GTPGW ($GTPGW_VTEP_IP)"
    ip route add $LLB_IP via $GTPGW_VTEP_IP dev $AP_VTEP_DEV

    log "*** you need to disable nat on the AP host ***"
    print_test
}

function ap_endpoint_down {
    log "cleanup start"

    log "delete route to LLB IP ($LLB_CIDR) via GTPGW ($GTPGW_VTEP_IP)"
    ip route del $LLB_CIDR via $GTPGW_VTEP_IP dev $AP_VTEP_DEV

    log "set vxlan device ($AP_VTEP_DEV) DOWN"
    ip link set down dev $AP_VTEP_DEV

    log "delete vxlan device ($AP_VTEP_DEV)"
    ip link del $AP_VTEP_DEV

    log "cleanup finished"
}

if [ "$1" = "add" ]; then
    ap_endpoint_up
elif [ "$1" = "del" ]; then
    ap_endpoint_down
else
    echo "This creates a vxlan endpoint on ap side"
    echo ""
    echo "  Usage: $0 <add|del>"
    echo ""
fi

