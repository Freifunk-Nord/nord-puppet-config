#!/bin/bash
#https://github.com/ffnord/ffnord-puppet-gateway

#backborts einbauen
echo "deb http://http.debian.net/debian wheezy-backports main" >>/etc/apt/sources.list

#sysupgrade
apt-get update && apt-get upgrade && apt-get dist-upgrade

#Benutzer hinzufügen

#MOTD setzen
rm /etc/motd
echo "*********************************************************" >>/etc/motd
echo " Freifunk Community Nord - Gateway $$ " >>/etc/motd
echo " Betreiber: $$ *" >>/etc/motd
echo "*******************************************************" >>/etc/motd
echo " " >>/etc/motd
echo " Hinweis(e): " >>/etc/motd
echo " - " >>/etc/motd
echo " " >>/etc/motd
echo " Log: " >>/etc/motd
echo " https://bug.freifunk.net/projects/ffnord-admin " >>/etc/motd
echo " *" >>/etc/motd
echo " Viel Spaß am Gerät! *" >>/etc/motd
echo "**********************************************************" >>/etc/motd

#Hostname setzen
hostname nord-gw11
echo "127.0.1.1 vpn$$.fnord.net nord-gw$$" >>/etc/hosts
rm /etc/hostname
echo "nord-gw$$" >>/etc/hostname
#benötigte Pakete installieren
apt-get -y install sudo apt-transport-https git tcpdump mtr-tiny vim nano unp mlocate screen cmake build-essential libcap-dev pkg-config libgps-dev python3 ethtool lsb-release zip

#REBOOT bei Kernel Panic
echo "kernel.panic = 10" >>/etc/sysctl.conf

#puppet Module installieren
apt-get -y install --no-install-recommends puppet
puppet module install puppetlabs-stdlib && puppet module install puppetlabs-apt --version 1.5.1 && puppet module install puppetlabs-vcsrepo && puppet module install saz-sudo && puppet module install torrancew-account
cd /etc/puppet/modules
git clone https://github.com/ffnord/ffnord-puppet-gateway ffnord

#check-services Script installieren
cd /usr/local/bin
wget --no-check-certificate https://raw.githubusercontent.com/Tarnatos/check-service/master/check-services
chmod +x check-services
chown root:root check-services

#zurück zu root
cd /root

#USER TODO:
#manifest.pp, $keys, mesh_peerings.yaml nach root legen
