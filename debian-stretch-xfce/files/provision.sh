#!/bin/bash

# Copie de qques fichiers
cp /vagrant/files/sources.list /etc/apt/sources.list
cp /vagrant/files/keyboard /etc/default/keyboard

# MAJ et install
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 vim xfce4 lightdm firefox-esr gnome-terminal firmware-atheros firmware-misc-nonfree tcpdump dsniff whois postgresql wireshark dkms net-tools # keyboard-configuration  wireshark
apt-get clean


# Localisation fr
echo "Europe/Paris" > /etc/timezone
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
dpkg-reconfigure -f noninteractive tzdata
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen
echo 'LANG="fr_FR.UTF-8"'>/etc/default/locale
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=fr_FR.UTF-8


# Creation des utilisateurs
usermod -p `mkpasswd --method=sha-512 root` root
useradd -m -s "/bin/bash" -p `mkpasswd --method=sha-512 debian` debian || true


# guest utils et reboot
/vagrant/files/VBoxLinuxAdditions.run
reboot

