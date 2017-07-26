#!/bin/bash

# Commercial

#ip route flush 0/0
#ip route add default via 192.168.1.1

# ip route add 192.168.1.0/24 via 10.0.0.2

#DEBIAN_FRONTEND=noninteractive apt-get remove -y lightdm
systemctl set-default graphical.target

DEBIAN_FRONTEND=noninteractive apt-get install -y thunderbird

#network config and prevent direct routing to internet
cp /vagrant/files/commercial/interfaces /etc/network/interfaces.d/commercial
echo "supersede routers 1.1.1.1;" >> /etc/dhcp/dhclient.conf
echo "supersede domain-name-servers 192.168.1.2;" >> /etc/dhcp/dhclient.conf
echo "supersede domain-name \"target.virt\";" >> /etc/dhcp/dhclient.conf

tar zxvf /vagrant/files/commercial/thunderbird.tar.gz -C /home/debian/

reboot
