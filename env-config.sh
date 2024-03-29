#!/bin/bash


############### common config ##################
GTPGW_IP="192.168.1.66"
UPF_IP="192.168.1.65"

#UP_SUBNET="192.168.3.0/24"


############# vxlan tunnel config ##############
GTPGW_VTEP_IP="192.168.3.100"
GTPGW_VTEP_CIDR="$GTPGW_VTEP_IP/24"
GTPGW_DEV="enp0s8"
GTPGW_VTEP_DEV="vxlan0"

UPF_VTEP_IP="192.168.3.200"
UPF_VTEP_CIDR="$UPF_VTEP_IP/24"
UPF_DEV="enp0s8"
UPF_VTEP_DEV="vxlan0"

# Using 192.168.3.0/24 for the AP might be
# confusing. It could have been another subnet
# but that will need another VTEP on the GTPGW
# which is something i don't want to do. Why ? 
# because i'm lazy..
AP_VTEP_IP="192.168.3.50"
AP_VTEP_CIDR="$AP_VTEP_IP/24"
AP_DEV=wlx888279170da7
AP_VTEP_DEV="vxlan0"

################ gtp-gw config #################
GTP_DEV="gtp0"
GTP_TOOLS_PATH="/home/vagrant/libgtpnl/tools"

TEID_IN="200"
TEID_OUT="100"

UE_IP="10.10.10.10"
UE_CIDR="$UE_IP/32"


################## upf config ##################
UPF_N3_VETH_DEV="n3-veth"
UPF_N3_HOST_DEV="n3"

UPF_N3_VETH_IP="192.168.3.1"
UPF_N3_VETH_CIDR="$UPF_N3_VETH_IP/24"
UPF_N3_HOST_IP="192.168.3.2"
UPF_N3_HOST_CIDR="$UPF_N3_HOST_IP/24"

UPF_GTPU_TEP_IP=$UPF_N3_HOST_IP

UPF_N4_VETH_DEV="n4-veth"
UPF_N4_HOST_DEV="n4"

UPF_N4_VETH_IP="192.168.4.1"
UPF_N4_VETH_CIDR="$UPF_N4_VETH_IP/24"
UPF_N4_HOST_IP="192.168.4.2"
UPF_N4_HOST_CIDR="$UPF_N4_HOST_IP/24"

UPF_N61_VETH_DEV="n6-pri-veth"
UPF_N61_HOST_DEV="n6-pri"

UPF_N61_VETH_IP="192.168.61.1"
UPF_N61_VETH_CIDR="$UPF_N61_VETH_IP/24"
UPF_N61_HOST_IP="192.168.61.2"
UPF_N61_HOST_CIDR="$UPF_N61_HOST_IP/24"

UPF_N62_VETH_DEV="n6-sec-veth"
UPF_N62_HOST_DEV="n6-sec"

UPF_N62_VETH_IP="192.168.62.1"
UPF_N62_VETH_CIDR="$UPF_N62_VETH_IP/24"
UPF_N62_HOST_IP="192.168.62.2"
UPF_N62_HOST_CIDR="$UPF_N62_HOST_IP/24"

LLB_IP="10.20.20.10"
LLB_CIDR="$LLB_IP/32"

