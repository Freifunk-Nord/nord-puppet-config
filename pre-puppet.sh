#!/bin/bash
#https://github.com/ffnord/ffnord-puppet-gateway
# adapt IPV6 first!

NAME="Freifunk Nord"
OPERATOR="Freifunk Nord"
CHANGELOG="https://osticket.freifunknord.de/scp/"
HOST_PREFIX="nord-"
SUBDOMAIN_PREFIX=hypergw
VPN_NUMBER=3
DOMAIN="freifunknord.net"
SUDOUSERNAME="root"
TLD=ffnord

#MOTD setzen
rm /etc/motd
echo "*********************************************************" >>/etc/motd
echo " $NAME - Gateway $VPN_NUMBER.$SUBDOMAIN_PREFIX.$DOMAIN $NAME " >>/etc/motd
echo " Hoster: $OPERATOR *" >>/etc/motd
echo "*******************************************************" >>/etc/motd
echo " " >>/etc/motd
echo " Changelog: " >>/etc/motd
echo " $CHANGELOG " >>/etc/motd
echo " *" >>/etc/motd
echo " Happy Hacking! *" >>/etc/motd
echo "**********************************************************" >>/etc/motd

#USER TODO:
echo 'now copy the files manifest.pp and mesh_peerings.yaml to /opt and make sure /opt/fastd_secret.key exists'
echo 'adapt IPV6 adress'
echo '####################################################################################'
echo '########### don´t run the following scripts without screen sesssion!!! #############'
echo '####################################################################################'
cat $(dirname $0 )/README.md
