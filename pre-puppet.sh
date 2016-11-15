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
TLD=ffnord

#backborts einbauen
echo "deb http://http.debian.net/debian wheezy-backports main" >>/etc/apt/sources.list

#sysupgrade
apt-get update && apt-get upgrade && apt-get dist-upgrade

#add users:
useradd -U -G sudo -m $SUDOUSERNAME

#MOTD setzen
rm /etc/motd
echo "*********************************************************" >>/etc/motd
echo " $NAME - Gateway $SUBDOMAIN_PREFIX$VPN_NUMBER $NAME " >>/etc/motd
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
apt-get -y install sudo apt-transport-https bash-completion haveged git tcpdump mtr-tiny vim nano unp mlocate screen tmux cmake build-essential libcap-dev pkg-config libgps-dev python3 ethtool lsb-release zip locales-all

#REBOOT on Kernel Panic
echo "kernel.panic = 10" >>/etc/sysctl.conf

#puppet modules install
apt-get -y install --no-install-recommends puppet
puppet module install puppetlabs-stdlib && puppet module install puppetlabs-apt --version 1.5.1 && puppet module install puppetlabs-vcsrepo --version 1.3.2 && puppet module install saz-sudo && puppet module install torrancew-account
cd /etc/puppet/modules
git clone https://github.com/ffnord/ffnord-puppet-gateway ffnord

#check-services script install
cd /usr/local/bin
wget --no-check-certificate https://raw.githubusercontent.com/Tarnatos/check-service/master/check-services
chmod +x check-services
chown root:root check-services
sed -i s/=ffki/=$TLD/g /usr/local/bin/check-services

# uncomment and add aliases
sed -i '/alias/s/^# //g' /root/.bashrc
echo 'alias ..="cd .."' >> /root/.bashrc
echo 'alias grep="grep --color=auto"' >> /root/.bashrc

# back in /root
cd /root

#USER TODO:
echo 'now copy the files manifest.pp and mesh_peerings.yaml to /root and make sure /root/fastd_secret.key exists'
echo '####################################################################################'
echo '########### don´t run the following scripts without screen sesssion!!! #############'
echo '####################################################################################'
cat $(dirname $0 )/README.md
