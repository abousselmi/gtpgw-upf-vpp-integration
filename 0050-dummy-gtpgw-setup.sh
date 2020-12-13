#!/bin/bash

# author: abousselmi

set -e

if [ "$EUID" -ne 0 ] ; then
    echo "Please run as root"
    exit 1
fi

## Configuration (Playing RAN)
source ./env-config.sh

## Logger
function log {
    echo -e "$(date +%F-%T) | $(hostname) | INFO | $1"
    sleep 1
}

function print_test_msg {
    echo ""
    echo "You can do for e.g.:"
    echo "  ping $LLB_IP"
    echo ""
    echo "Using tshark you will see ICMP pckets encapsulated in GTP"
    echo ""
}

## Create veth pairs, gtp namespaces and ifaces
function start {
    log "set ip address of loopback iface"
    ip addr add $UE_CIDR dev lo || true

    log "create gtp device (run in bg mode)"
    $GTP_TOOLS_PATH/gtp-link add $GTP_DEV &

    log "configure mtu of gtp device"
    ifconfig $GTP_DEV mtu 1500 up

    log "create gtp tunnel"
    $GTP_TOOLS_PATH/gtp-tunnel add $GTP_DEV v1 $TEID_IN $TEID_OUT $LLB_IP $UPF_IP
    log "$(./gtp-tunnel list)"

    log "configure service route using gtp device"
    ip route add $LLB_CIDR dev $GTP_DEV

    print_test_msg
}

## Destroy everything
function stop {
    log "delete loopback config"
    ip addr del $UE_CIDR dev lo

    log "remove n3 route"
    ip route del $LLB_CIDR dev $GTP_DEV

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
    echo "This is a simple emulator of a UP Access GTP Gateway"
    echo ""
    echo "  Usage: $0 <start|stop>"
    echo ""
fi

