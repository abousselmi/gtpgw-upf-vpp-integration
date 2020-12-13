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

# Note: adding NX_IP to nX makes VPP unable to use correctly nX as host-nX
# I did not dig deeper into this issue (a problem for the future me)

function add {
    log "create N3 veth pairs ($UPF_N3_HOST_DEV, $UPF_N3_VETH_DEV)"
    ip link add $UPF_N3_HOST_DEV type veth peer name $UPF_N3_VETH_DEV
    ip link set $UPF_N3_HOST_DEV up
    ifconfig $UPF_N3_HOST_DEV mtu 1500 up
    ip link set $UPF_N3_VETH_DEV up
    ifconfig $UPF_N3_VETH_DEV mtu 1500 up
    ip a add $UPF_N3_VETH_CIDR dev $UPF_N3_VETH_DEV

    log "add a route to host-n3 ip ($UPF_N3_HOST_IP)"
    # this is worth a lot of debugging. Finally a simple curl (what! yeah curl)
    # gave me a hint <3 No route to host <3
    ip route add $UPF_N3_HOST_IP via $UPF_N3_VETH_IP

    log "create N4 veth pairs ($UPF_N4_HOST_DEV, $UPF_N4_VETH_DEV)"
    ip link add $UPF_N4_HOST_DEV type veth peer name $UPF_N4_VETH_DEV
    ip link set $UPF_N4_HOST_DEV up
    ip link set $UPF_N4_VETH_DEV up
    ip a add $UPF_N4_VETH_CIDR dev $UPF_N4_VETH_DEV

    log "create Primary N6 veth pairs ($UPF_N61_HOST_DEV, $UPF_N61_VETH_DEV)"
    ip link add $UPF_N61_HOST_DEV type veth peer name $UPF_N61_VETH_DEV
    ip link set $UPF_N61_HOST_DEV up
    ip link set  $UPF_N61_VETH_DEV up
    ip a add $UPF_N61_VETH_CIDR dev $UPF_N61_VETH_DEV

    log "create Secondary N6 veth pairs ($UPF_N62_HOST_DEV, $UPF_N62_VETH_DEV)"
    ip link add $UPF_N62_HOST_DEV type veth peer name $UPF_N62_VETH_DEV
    ip link set $UPF_N62_HOST_DEV up
    ip link set $UPF_N62_VETH_DEV up
    ip a add $UPF_N62_VETH_CIDR dev $UPF_N62_VETH_DEV
}

function delete {
    IP_LINK_DEL="ip link delete"
    log "delete N3, N4, N6-pri and N6-sec devices"
    $IP_LINK_DEL $UPF_N3_HOST_DEV
    $IP_LINK_DEL $UPF_N4_HOST_DEV
    $IP_LINK_DEL $UPF_N61_HOST_DEV
    $IP_LINK_DEL $UPF_N62_HOST_DEV
}

if [ "$1" = "add" ]; then
    add
elif [ "$1" = "del" ]; then
    delete
else
    echo ""
    echo "  Usage: $0 <add|del>"
    echo ""
fi

