#!/bin/bash

# FIREWALL

#ip route flush 0/0
#ip route add default via 192.168.1.1

# ip route add 192.168.1.0/24 via 10.0.0.2

#DEBIAN_FRONTEND=noninteractive apt-get remove -y lightdm
systemctl set-default multi-user.target

#network config and prevent direct routing to internet
cp /vagrant/files/firewall/interfaces /etc/network/interfaces.d/firewall
echo "supersede routers 1.1.1.1;" >> /etc/dhcp/dhclient.conf
echo "supersede domain-name-servers 192.168.1.2;" >> /etc/dhcp/dhclient.conf
echo "supersede domain-name \"target.virt\";" >> /etc/dhcp/dhclient.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
cp /vagrant/files/firewall/rc.local /etc/rc.local

reboot
