#!/bin/bash
#https://github.com/ffnord/ffnord-puppet-gateway

NAME="Freifunk Nord"
OPERATOR="Max"
CHANGELOG="https://bug.freifunk.net/projects/ffnord-admin"
HOST_PREFIX="nord-gw"
SUBDOMAIN_PREFIX=vpn
VPN_NUMBER=0
DOMAIN="nord.freifunk.net"
SUDOUSERNAME="maximilian"

#backborts einbauen
echo "deb http://http.debian.net/debian wheezy-backports main" >>/etc/apt/sources.list

#sysupgrade
apt-get update && apt-get upgrade && apt-get dist-upgrade

#add users:
useradd -U -G sudo -m $SUDOUSERNAME

#MOTD setzen
rm /etc/motd
echo "*********************************************************" >>/etc/motd
echo " $NAME - Gateway $NAME " >>/etc/motd
echo " Hoster: $OPERATOR *" >>/etc/motd
echo "*******************************************************" >>/etc/motd
echo " " >>/etc/motd
echo " Changelog: " >>/etc/motd
echo " $CHANGELOG " >>/etc/motd
echo " *" >>/etc/motd
echo " Happy Hacking! *" >>/etc/motd
echo "**********************************************************" >>/etc/motd

#Hostname setzen
hostname $HOST_PREFIX$VPN_NUMBER
echo "127.0.1.1 $SUBDOMAIN_PREFIX$VPN_NUMBER.$DOMAIN $HOST_PREFIX$VPN_NUMBER" >>/etc/hosts
rm /etc/hostname
echo "$HOST_PREFIX$VPN_NUMBER" >>/etc/hostname
#benötigte Pakete installieren
apt-get -y install sudo apt-transport-https haveged git tcpdump mtr-tiny vim nano unp mlocate screen cmake build-essential libcap-dev pkg-config libgps-dev python3 ethtool lsb-release zip locales-all

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
sed -i s/=ffki/=fmdk/g /usr/local/bin/check-services

#zurück zu root
cd /root

#USER TODO:
echo 'now copy the files manifest.pp, fastd_secret.key and mesh_peerings.yaml to /root'
echo 'and then start puppet apply --verbose /root/manifest.pp'
echo 'don´t run those scripts without screen sesssion!!!'
