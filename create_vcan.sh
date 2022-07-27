#!/bin/bash

sudo modprobe vcan
sudo ip link add dev vcan0 type vcan
sudo ip link set up vcan0

#Send a CAN signal
#cansend vcan0 01a#11223344AABBCCDD

#Random gen: CAN signals
#cangen vcan0 -v 
