#./boot.sh
#./configure --with-linux=/lib/modules/`uname -r`/build

# Clean up
#sudo mn -c
#sudo kill `cd /usr/local/var/run/openvswitch && cat ovsdb-server.pid ovs-vswitchd.pid`

## build and install
#sudo make
#sudo make install
#sudo make modules_install

# init ovs
#sudo rm /usr/local/etc/openvswitch/conf.db
#sudo ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema

sudo ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
                  --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
                  --private-key=db:Open_vSwitch,SSL,private_key \
                  --certificate=db:Open_vSwitch,SSL,certificate \
                  --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
                  --pidfile --detach --log-file

sudo ovs-vsctl --no-wait init
sudo ovs-vswitchd --pidfile --detach --log-file

# reload kernel module
#sudo /sbin/rmmod openvswitch
#sudo /sbin/insmod /lib/modules/3.13.0-32-generic/extra/openvswitch.ko
modprobe openvswitch

echo "\n---------------------------------------"
sudo /sbin/lsmod | grep openvswitch
echo "\n---------------------------------------"
sudo ovs-vsctl --version

ovs-vsctl del-br br0
ovs-vsctl add-br br0
ovs-vsctl add-port br0 enx00e04c68037c
