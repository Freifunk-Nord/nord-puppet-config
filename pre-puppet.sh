#!/bin/bash
#https://github.com/ffnord/ffnord-puppet-gateway

NAME="Freifunk Nordheide"
OPERATOR="heini66"
CHANGELOG=""
HOST_PREFIX="gw"
SUBDOMAIN_PREFIX="gw"
VPN_NUMBER="00"
DOMAIN="nordheide.freifunk.net"
SUDOUSERNAME="heini66"
TLD=ffnh

#backports einbauen
echo "deb http://http.debian.net/debian jessie-backports main" >>/etc/apt/sources.list

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

#OVH
#Hostname setzen
#hostname $HOST_PREFIX$VPN_NUMBER
#echo "127.0.1.1 $SUBDOMAIN_PREFIX$VPN_NUMBER.$DOMAIN $HOST_PREFIX$VPN_NUMBER" >>/etc/hosts
#rm /etc/hostname
#echo "$HOST_PREFIX$VPN_NUMBER" >>/etc/hostname

# install needed packages
apt-get -y install sudo apt-transport-https git

# optional pre installed to speed up the setup:
apt-get -y install bash-completion haveged tcpdump mtr-tiny vim nano unp mlocate screen tmux cmake build-essential libcap-dev pkg-config libgps-dev python3 ethtool lsb-release zip locales-all

#puppet modules install
apt-get -y install --no-install-recommends puppet
puppet module install puppetlabs-stdlib --version 4.15.0 && \
puppet module install puppetlabs-apt --version 1.5.1 && \
puppet module install puppetlabs-vcsrepo --version 1.3.2 && \
puppet module install saz-sudo --version 4.1.0 && \
puppet module install torrancew-account --version 0.1.0
cd /etc/puppet/modules
git clone https://github.com/ffnord/ffnord-puppet-gateway ffnord

# add aliases
cat <<-EOF>> /root/.bashrc
  export LS_OPTIONS='--color=auto'
  eval" \`dircolors\`"
  alias ls='ls \$LS_OPTIONS'
  alias ll='ls \$LS_OPTIONS -lah'
  alias l='ls \$LS_OPTIONS -lA'
  alias grep="grep --color=auto"
  alias ..="cd .."
EOF

# back in /root
cd /root

echo load the ip_tables and ip_conntrack module
modprobe ip_conntrack
echo ip_conntrack >> /etc/modules

#USER TODO:
echo 'now copy the files manifest.pp and mesh_peerings.yaml to /root and make sure /root/fastd_secret.key exists'
echo '####################################################################################'
echo '########### don´t run the following scripts without screen sesssion!!! #############'
echo '####################################################################################'
cat $(dirname $0 )/README.md
