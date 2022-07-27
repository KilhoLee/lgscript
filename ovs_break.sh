#!/bin/bash

#rmmod openvswitch
ps ax | grep 'ovsdb-server' | awk '{print $1}' | xargs kill -9
ps ax | grep 'ovs-vswitchd' | awk '{print $1}' | xargs kill -9

echo 'OVS UNLOADED'

#sudo tc qdisc del dev root    

CONETH=enx001e06
ETHPREFIX=enx
ifconfig | grep ${ETHPREFIX} | awk '{if(index($1,"${CONETH}")==0) print $1}' | echo
