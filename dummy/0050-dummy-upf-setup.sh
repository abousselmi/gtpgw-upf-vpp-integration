#!/bin/bash

# author: abousselmi

set -e

if [ "$EUID" -ne 0 ] ; then
    echo "Please run as root"
    exit 1
fi

## Configuration (Playing UPF)
source ./env-config.sh

## Logger
function log {
    echo -e "$(date +%F-%T) | $(hostname) | INFO | $1"
    sleep 1
}

function print_test_msg {
    echo ""
    echo "You can do for e.g.:"
    echo "  ping $UE_IP"
    echo ""
    echo "Using tshark you will see ICMP pckets encapsulated in GTP"
    echo ""
}

## Create veth pairs, gtp namespaces and ifaces
function start {
    log "add llb ip address to loopback iface: $LLB_CIDR"
    ip addr add $LLB_CIDR dev lo || true

    log "create gtp device: $GTP_DEV"
    $GTP_TOOLS_PATH/gtp-link add $GTP_DEV &

    log "set gtp device mtu to 1500"
    ifconfig $GTP_DEV mtu 1500 up

    log "create gtp tunnel"
    $GTP_TOOLS_PATH/gtp-tunnel add $GTP_DEV v1 $TEID_OUT $TEID_IN $UE_IP $GTPGW_VTEP_IP
    log "$($GTP_TOOLS_PATH/gtp-tunnel list)"

    log "configure ue route using gtp device"
    ip route add $UE_CIDR dev $GTP_DEV

    print_test_msg
}

## Destroy everything
function stop {
    log "delete loopback config"
    ip addr del $LLB_CIDR dev lo

    log "remove n3 route"
    ip route del $UE_CIDR dev $GTP_DEV

    log "remove gtp devices"
    $GTP_TOOLS_PATH/gtp-link del $GTP_DEV

    log "send a SIGKILL to gtp-link process"
    LINK_PID=$(pgrep gtp-link)
    if [ "$LINK_PID" != "" ] ; then
      kill -9 $LINK_PID
    fi
}

if [ "$1" = "start" ]; then
    start
elif [ "$1" = "stop" ]; then
    stop
else
    echo "This is a simple emulator of a UPF GTP Endpoint"
    echo ""
    echo "  Usage: $0 <start|stop>"
    echo ""
fi

