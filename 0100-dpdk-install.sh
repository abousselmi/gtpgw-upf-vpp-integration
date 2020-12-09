#!/bin/bash

# author: abousselmi

set -e

DPDK_RELEASE="20.08"

function log {
    echo "$(date) | INFO | $1"
}

log "start dpdk setup.."

export DEBIAN_FRONTEND=noninteractive

log "install dpdk build dependencies"
apt-get update -qq && apt-get install -y \
    build-essential \
    python3 \
    meson \
    ninja-build \
    libnuma-dev \
    linux-headers-$(uname -r) \
    pkg-config \
    cmake

log "install other dpdk dependencies"
apt-get install -y \
    libbsd-dev \
    libpcap-dev \
    libjansson-dev \
    libelf-dev \
    ibverbs-providers \
    libbpfcc-dev \
    zlib1g-dev \
    libfdt-dev \
    libipsec-mb-dev \
    libisal-dev \
    python3-sphinx

log "reserving hugepages for dpdk use"
if [ "$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)" = "0" ]; then
    echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
else
    log "hugepages is already researved"
fi

log "using hugepages with the dpdk"
if [ -d "/mnt/huge" ]; then
    log "hugepages is already in use"
else
    mkdir /mnt/huge
    mount -t hugetlbfs nodev /mnt/huge
    echo "nodev /mnt/huge hugetlbfs defaults 0 0" >> /etc/fstab
fi

log "download dpdk-$DPDK_RELEASE.tar.xz.."
wget --quiet http://fast.dpdk.org/rel/dpdk-$DPDK_RELEASE.tar.xz
tar xJf dpdk-$DPDK_RELEASE.tar.xz
rm dpdk-$DPDK_RELEASE.tar.xz

log "build and install dpdk"
cd dpdk-$DPDK_RELEASE
meson build
cd build
ninja
ninja install
ldconfig

log "verify installation"
if [ $(which dpdk-proc-info) = "" ]; then
    log "install is nok.."
else
    log "install is ok!"
fi

log "dpdk setup is done."
