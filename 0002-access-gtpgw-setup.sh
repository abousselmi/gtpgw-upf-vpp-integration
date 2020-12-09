#!/bin/bash

# author: abousselmi

set -e

if [ "$EUID" -ne 0 ] ; then
    echo "Please run as root"
    exit 1
fi

## Configuration (RAN N3 endpoint emulator)
source ./0001-env-config.sh

function log {
    echo -e "$(date +%F-%T) | $(hostname) | INFO | $1"
    sleep 1
}

function print_test_msg {
    echo ""
    echo "You can do for e.g.:"
    echo "  ping $LLB_IP"
    echo ""
    echo "Using tshark you should be able to see ICMP pckets encapsulated in GTP"
    echo ""
}

## Create veth pairs, gtp namespaces and ifaces
function start {
    log "create gtp device: $GTP_DEV"
    $GTP_TOOLS_PATH/gtp-link add $GTP_DEV &

    log "set gtp device mtu to 1500"
    ifconfig $GTP_DEV mtu 1500 up

    log "create gtp tunnel endpoint"
    $GTP_TOOLS_PATH/gtp-tunnel add $GTP_DEV v1 $TEID_IN $TEID_OUT $LLB_IP $UPF_VTEP_IP
    log "$($GTP_TOOLS_PATH/gtp-tunnel list)"

    log "configure llb route using gtp device"
    ip route add $LLB_CIDR dev $GTP_DEV

    print_test_msg
}

## Destroy everything
function stop {
    log "remove n3 route"
    ip route del $LLB_CIDR dev $GTP_DEV || true

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

