# This script is currently not working due to the dependency of additional libraries (cyaml)


#!/bin/bash
# This build script has been written for cross-compiling of OVS.
# The target device: ODROID-XU4 (ARMv7)
# Used cross compiler: arm-linux-gnueabihf-gcc-9


# BootStrap
# The bootstrap stage only requires to be executed once, at the very first of the build.
# (Could be skipped.)
#./boot.sh

#./configure --with-sysroot=/usr/arm-linux-gnueabihf --host=arm \
#CC=arm-linux-gnueabihf-gcc-9 AR=arm-linux-gnueabihf-ar LD=arm-linux-gnueabihf-ld RANLIB=arm-linux-gnueabihf-ranlib STRIP=arm-linux-gnueabihf-strip \

# The following configure is for including the kernel module (the datapath)
#KDIR=/home/khlee/mcsdn/kernel/odroid-3.10
#./configure --with-linux=${KDIR} KARCH=arm ARCH=arm \
#CC=arm-linux-gnueabihf-gcc AR=arm-linux-gnueabihf-ar LD=arm-linux-gnueabihf-ld RANLIB=arm-linux-gnueabihf-ranlib STRIP=arm-linux-gnueabihf-strip \
#CFLAGS="-L/home/khlee/mcsdn/cross_odlibs -march=armv7-a" \
#--host=arm \

# Make & install 
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- \
CFLAGS="-L/home/khlee/lgsdn/libodroid -I/home/khlee/lgsdn/libodroid/include -Wl,-rpath-link /home/khlee/lgsdn/libodroid" 

# Deploy, when the compilation has been done with no errors # 
if [ $? == "0" ]
then
	TARGET=rl
	#ssh ${TARGET} /root/sc/ovs_break.sh
	sleep 2
	#scp datapath/linux/openvswitch.ko ${TARGET}:/lib/modules/3.10.104+/extra/
	scp ovsdb/ovsdb-server ${TARGET}:/usr/local/sbin
	scp vswitchd/ovs-vswitchd ${TARGET}:/usr/local/sbin
	sleep 2
	#ssh ${TARGET} /root/sc/ovs_start.sh
fi
