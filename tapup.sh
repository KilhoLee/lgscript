#!/bin/bash

ip tuntap add dev tap0 mode tap
ifconfig tap0 up

#sysctl -w net.ipv6.conf.all.disable_ipv6=1
#sysctl -w net.ipv6.conf.default.disable_ipv6=1

ovs-vsctl add-port br0 tap0
