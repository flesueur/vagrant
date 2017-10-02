#!/bin/bash

# DMZ

#ip route flush 0/0
#ip route add default via 192.168.1.1

# ip route add 192.168.1.0/24 via 10.0.0.2

#DEBIAN_FRONTEND=noninteractive apt-get remove -y lightdm
systemctl set-default multi-user.target

DEBIAN_FRONTEND=noninteractive apt-get install -y unbound postfix dovecot-imapd proftpd apt-transport-https

#network config and prevent direct routing to internet
cp /vagrant/files/dmz/interfaces /etc/network/interfaces.d/dmz
echo "supersede routers 1.1.1.1;" >> /etc/dhcp/dhclient.conf
echo "supersede domain-name-servers 192.168.1.2;" >> /etc/dhcp/dhclient.conf
echo "supersede domain-name \"target.virt\";" >> /etc/dhcp/dhclient.conf

cp /vagrant/files/dmz/dns.conf /etc/unbound/unbound.conf.d/

sed -i -e 's/ssl = no/ssl = yes/' /etc/dovecot/conf.d/10-ssl.conf
echo "ssl_cert = </etc/ssl/certs/ssl-cert-snakeoil.pem" >> /etc/dovecot/conf.d/10-ssl.conf
echo "ssl_key = </etc/ssl/private/ssl-cert-snakeoil.key" >> /etc/dovecot/conf.d/10-ssl.conf

sed -i -e 's/mydestination = /mydestination = target.virt, /' /etc/postfix/main.cf
sed -i -e 's/mynetworks = /mynetworks = 192.168.0.0\/16 /' /etc/postfix/main.cf

useradd -m -s "/bin/bash" -p `mkpasswd --method=sha-512 commercial` commercial || true
useradd -m -s "/bin/bash" -p `mkpasswd --method=sha-512 @password` insa || true


cp /vagrant/files/dmz/ossec.list /etc/apt/sources.list.d/
wget -q -O /tmp/key https://www.atomicorp.com/RPM-GPG-KEY.art.txt
apt-key add /tmp/key
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-unauthenticated ossec-hids-server



reboot
