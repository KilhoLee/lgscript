#!/bin/bash

if [ $# -ne 1 ]
then
    echo "USAGE: $0 [up/down]"
    exit
fi

if [ $1 == "up" ]
then
    echo "LINK UP"
    echo "ssh rr ifconfig enx00e0813748f4 up"
    echo "ssh vcom ifconfig enx00e04c360b7c up"
    ssh rr ifconfig enx00e0813748f4 up
    ssh vcom ifconfig enx00e04c360b7c up
elif [ $1 == "down" ]
then
    echo "LINK DOWN"
    echo "ssh rr ifconfig enx00e0813748f4 down"
    echo "ssh vcom ifconfig enx00e04c360b7c down"
    ssh rr ifconfig enx00e0813748f4 down
    ssh vcom ifconfig enx00e04c360b7c down
fi



