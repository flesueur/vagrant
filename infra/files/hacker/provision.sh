#!/bin/bash

# Hacker

#ip route flush 0/0
#ip route add default via 192.168.1.1

# ip route add 192.168.1.0/24 via 10.0.0.2

#DEBIAN_FRONTEND=noninteractive apt-get remove -y lightdm
systemctl set-default graphical.target

DEBIAN_FRONTEND=noninteractive apt-get install -y thunderbird

#network config and prevent direct routing to internet
cp /vagrant/files/hacker/interfaces /etc/network/interfaces.d/hacker
echo "supersede routers 1.1.1.1;" >> /etc/dhcp/dhclient.conf
echo "supersede domain-name-servers 10.0.0.1;" >> /etc/dhcp/dhclient.conf
echo "supersede domain-name \"internet.virt\";" >> /etc/dhcp/dhclient.conf

tar zxvf /vagrant/files/hacker/thunderbird.tar.gz -C /home/debian/
#/usr/share/images/desktop-base/default

chown -R debian:debian /vagrant/files/hacker/homedir
cp -ar /vagrant/files/hacker/homedir/* /home/debian/
ln -sf /home/debian/background.jpg /usr/share/images/desktop-base/default

reboot
