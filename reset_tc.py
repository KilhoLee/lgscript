#!/usr/bin/python
#PYTHON: This script is a python script, not a bash shell script.
#PYTHON: Take care of the SYNTAX! 

from subprocess import *
import os

#CONETH = "enx00e0"
CONETH = "enx001e06"
ETHPREFIX="enx"

# In order to get proper PATH env for ssh non-interactive shells #
os.putenv('PATH', "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/home/root/ovs/bin:/home/root/ovs/sbin")

cmd = '''ifconfig | grep %s | awk '{if(index($1,"%s")==0) print $1}' ''' % (ETHPREFIX,CONETH)
cmd_list = cmd.split(' ')

p = Popen(cmd, shell=True, stdout=PIPE)
ifaces = p.stdout.readlines()

# TC-HTB Qdisc setup for all interfaces 
cmd = []
for iface in sorted(ifaces):
    if ETHPREFIX in iface:
        iname = iface.rstrip('\n')
        cmdstring = '/sbin/tc qdisc del dev %s root' % iname
        cmd.append(cmdstring)

for c in cmd:
    os.system (c)
print 'TC SETUP RESET Done, for [ %d ] Ports' % len(ifaces)

