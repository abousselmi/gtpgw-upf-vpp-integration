# Build GTP kernel module

This is my list of steps to build a kernel module. In this case we are building gtp.ko

## Step 1: Install Deps

Build deps:

```console
sudo apt install build-essential libtool gcc make autoconf automake pkg-config libmnl-dev autogen
```

Kernel specific build deps

```console
sudo apt install libncurses-dev flex bison openssl libssl-dev libelf-dev
```

## Step 2: Get kernel source

The following are two methods to get the kernel source.

NOK: did not work the second time !!!

```console
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
git tag -l | grep X.Y
git checkout vX.Y
```

OK: this works fine (did not the first time..)

```console
sudo apt install linux-source linux-source-X-Y-z
cd /usr/src/linux-source-5.4.0/
sudo tar -xf linux-source-5.4.0.tar.bz2
cd linux-source-5.4.0/
```

## Step 3: Prepare

```console
cp /usr/src/linux-headers-$(uname -r)/Module.symvers .
cp /boot/config-5.4.0-51-generic .config
```

```console
mkdir drivers/net/gtp/
cp drivers/net/gtp.c drivers/net/gtp/
vim drivers/net/gtp/Makefile
```

The content of the `Makefile is the following

```console
obj-$(CONFIG_GTP) += gtp.o
```

## Step 4: Compile for a specifc version 

In this example, the target is `5.4.0-51-generic` kernel version.

```console
make VERSION="5" PATCHLEVEL="4" SUBLEVEL="0-51-generic" modules_prepare
make -C . M=drivers/net/gtp
modinfo drivers/net/gtp/gtp.ko
sudo cp drivers/net/gtp/gtp.ko /lib/modules/$(uname -r)/kernel/drivers/net/
sudo depmod
sudo modprobe gtp
```

Check the result

```console
modinfo gtp
lsmod | grep gtp
```

## Troubleshouting

To debug in case of any problem (helped a lot)

```console
dmesg
```

