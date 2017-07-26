#!/bin/bash

# BACKBONE

#ip route flush 0/0
#ip route add default via 192.168.1.1

# ip route add 192.168.1.0/24 via 10.0.0.2

#DEBIAN_FRONTEND=noninteractive apt-get remove -y lightdm
systemctl set-default multi-user.target
#systemctl set-default graphical.target

DEBIAN_FRONTEND=noninteractive apt-get install -y unbound postfix dovecot-imapd

cp /vagrant/files/backbone/interfaces /etc/network/interfaces.d/backbone
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
cp /vagrant/files/backbone/rc.local /etc/rc.local

echo "supersede domain-name-servers 10.0.0.1;" >> /etc/dhcp/dhclient.conf
echo "supersede domain-name \"internet.virt\";" >> /etc/dhcp/dhclient.conf

cp /vagrant/files/backbone/dns.conf /etc/unbound/unbound.conf.d/


sed -i -e 's/ssl = no/ssl = yes/' /etc/dovecot/conf.d/10-ssl.conf
echo "ssl_cert = </etc/ssl/certs/ssl-cert-snakeoil.pem" >> /etc/dovecot/conf.d/10-ssl.conf
echo "ssl_key = </etc/ssl/private/ssl-cert-snakeoil.key" >> /etc/dovecot/conf.d/10-ssl.conf

sed -i -e 's/mydestination = /mydestination = internet.virt, /' /etc/postfix/main.cf
sed -i -e 's/mynetworks = /mynetworks = 10.0.0.0\/24 /' /etc/postfix/main.cf

useradd -m -s "/bin/bash" -p `mkpasswd --method=sha-512 hacker` hacker || true


reboot
