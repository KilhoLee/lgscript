#!/bin/bash -xe
 
argc=$#
argv0=$0
 
EXISTING_IF_NAME="$1"
SOMEIP_UNICAST_IP="$2"
VLAN_ID=20
#SOMEIP_INTERFACE="$1.$VLAN_ID"
SOMEIP_INTERFACE="br0.$VLAN_ID"
MULTICAST_IP="239.$VLAN_ID.0.1"
 
if [ $argc -lt 1 ]
then
    echo -e "\nPlease run ifconfig and check your ethernet interface.\nEx) eth0 192.168.1.11 \n"
else
    sudo ip link add link "$EXISTING_IF_NAME" name "$SOMEIP_INTERFACE" type vlan id "$VLAN_ID"
    sudo ifconfig "$SOMEIP_INTERFACE" "$SOMEIP_UNICAST_IP" netmask 255.255.255.0 up
    sudo route add -n "$MULTICAST_IP" "$SOMEIP_INTERFACE"
fi
