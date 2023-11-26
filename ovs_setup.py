#PYTHON: This script is a python script, not a bash shell script.
#PYTHON: Take care of the SYNTAX! 

from subprocess import *
import os

#CONETH = "enx00e0"
CONETH = "enx001e06"
ETHPREFIX="enx"

conmode='outband'    # 'inband' or 'outband'
#CONIPADDR="10.0.0.55"
CONIPADDR="192.168.5.45"
queuemode = 'noq'   # 'noq', 'htb', or 'prio'
#queuemode = 'htb'   # 'noq', 'htb', or 'prio'

htbrates = [70,20,1,1,1,1,1,1]  # HTB will have 8 sub-queues. 

#NOTE: MYID Should be up to two digits (It will be used as a part of MAC addr as is)
CONPORT=6633
MYID=
BR_ADDRPRFIX="10.0.0"
BR_MACPREFIX="00:00:00:00:00"

CEIL = 95

# In order to get proper PATH env for ssh non-interactive shells #
os.putenv('PATH', "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/home/root/ovs/bin:/home/root/ovs/sbin")

cmd = '''ifconfig | grep %s | awk '{if(index($1,"%s")==0) print $1}' ''' % (ETHPREFIX,CONETH)
cmd_list = cmd.split(' ')

p = Popen(cmd, shell=True, stdout=PIPE)
ifaces = p.stdout.readlines()

cmd = ['ovs-vsctl add-br br0']

#Should attach ports 
for iface in sorted(ifaces):
    if ETHPREFIX in iface:
        iname = iface.rstrip('\n')
        if iname[-1] == ":":
            iname = iname[:-1]
        cmd.append('ovs-vsctl add-port br0 %s' % iname)

if conmode=='inband':
    print ("CONTROL MODE = INBAND, STATIC ARP TABLE UPDATED")
    cmd.append ('ovs-vsctl set bridge br0 other-config=disable-in-band=false')
elif conmode=='outband':
    print ("CONTROL MODE = OUT-OF-BAND, STATIC ARP TABLE UPDATED")

cmd.append ('ovs-vsctl set bridge br0 other-config:hwaddr=%s:%d' % (BR_MACPREFIX, MYID))
cmd.append ('ifconfig br0 inet %s.%d' % (BR_ADDRPRFIX, MYID))
cmd.append ('bash /root/static_arp.sh')
cmd.append ('sleep 1')
cmd.append ('ovs-vsctl set-controller br0 tcp:%s:%s' % (CONIPADDR, CONPORT) )

#Apply cmds
for c in cmd:
    os.system(c)

print 'OVS SETUP Done, for [ %d ] Ports' % len(ifaces)

#TC-PRIO Qdisc setup for all interfaces
#For all ports attached to the OVS.
if queuemode == 'prio': 
    cmd = []
    for iface in sorted(ifaces):
        if ETHPREFIX in iface:
            iname = iface.rstrip('\n')
            cmdstring = '/sbin/tc qdisc add dev %s root handle 1: prio bands 16 ' % iname
            cmdstring += 'priomap 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15'
            cmd.append(cmdstring)

# TC-HTB Qdisc setup for all interfaces 
elif queuemode == 'htb':
    cmd = []
    for iface in sorted(ifaces):
        if ETHPREFIX in iface:
            iname = iface.rstrip('\n')
            cmdstring = '/sbin/tc qdisc add dev %s root handle 1: htb default 9' % iname
            cmd.append(cmdstring)
            cmdstring = '/sbin/tc class add dev %s parent 1:0 classid 1:1 htb rate 99Mbit' % iname 
            cmd.append(cmdstring)
            for i in range(8):
                cmdstring = '/sbin/tc class add dev %s parent 1:1 classid 1:%d htb rate %dMbit ceil %dMbit prio %d' % (iname, i+2, htbrates[i], CEIL, i)
                cmd.append(cmdstring)

elif queuemode == 'noq':
    cmd = []
    for iface in sorted(ifaces):
        if ETHPREFIX in iface:
            iname = iface.rstrip('\n')
            cmdstring = '/sbin/tc qdisc show dev %s ' % iname
            cmd.append (cmdstring)
    cmd.append ('echo "NO TC QDISC SET"')

# Remove all Queues 
else:
    cmd = []
    for iface in sorted(ifaces):
        if ETHPREFIX in iface:
            iname = iface.rstrip('\n')
            cmdstring = '/sbin/tc qdisc del dev %s root' % iname
            cmd.append(cmdstring)

for c in cmd:
    os.system (c)
print 'TC QDISC SETUP Done (Mode: %s), [ %d Ports]' % (queuemode, len(ifaces))

