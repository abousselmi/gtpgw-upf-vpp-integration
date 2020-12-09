# GTPGW/UPF-VPP Helper Sripts

A set of scripts to configure:

- The GTP GW (or RAN emulator)
- The UPF (User Plane Function)

## Tree

```console
$ tree 
.
├── 0001-env-config.sh                     # network configurations (mainly)
├── 0001-vtep-gtpgw-setup.sh               # to create a VxLAN tunnel endpoint on the GTPGW host
├── 0001-vtep-upf-setup.sh                 # to create a VTEP on the UPF host
├── 0002-access-gtpgw-setup.sh             # to create the GTPU tunnel device and configure UL
├── 0002-llb-endpoint-setup.sh             # to create the LLB endpoint on UPF machine (place holder for the real LLB)
├── 0002-ue-endpoint-setup.sh              # to create the UE endpoint on the GTPGW host (a place holder for the real UEs)
├── 0002-upf-ue-route-setup.sh             # to add a static route to UE IP via N6 (needed for the DL)
├── 0002-vpp-veths-setup.sh                # to create VETH pairs for the UPF/VPP
├── 0003-init.conf                         # a sample config file of UPF/VPP using VETH pairs
├── 0003-session.yaml                      # a sample session file used by the Fred's PFCP session injector
├── 0003-startup_debug.conf                # a sample debug startup config file for UPF/VPP
├── 0050-dummy-gtpgw-setup.sh              # a dummy gtpgw setup script (use 0002-access-gtpgw-setup.sh instead)
├── 0050-dummy-upf-setup.sh                # a dummy upf gtp endpoint emulator (for testing)
├── 0100-dpdk-install.sh                   # a script to install dpdk deps (experimental)
├── 0100-netplan-bridge-config.yaml        # a sample config to bridge an interface using netplan
├── 0200-gtp-kernel-module.md              # a list of steps to compile the gtp kernel module
└── README.md                              # this file :)

0 directories, 16 files
```


