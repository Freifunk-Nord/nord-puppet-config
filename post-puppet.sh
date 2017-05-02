#!/bin/bash
#https://github.com/ffnord/ffnord-puppet-gateway

VPN_NUMBER="00"
#DOMAIN=nord.freifunk.net
TLD=ffnh
IP6PREFIX=fd8f:14c7:d318

#NGINX, if needed to serve the firmware for the auto-updater
#apt-get install -y nginx

#mkdir /opt/www
#sed s~"usr/share/nginx/www;"~"opt/www;"~g -i /etc/nginx/sites-enabled/default

#DNS Server
#sed -i .bak "/eth0 inet static/a \  dns-search vpn$VPN_NUMBER.$DOMAIN" /etc/network/interfaces

#rm /etc/resolv.conf
#cat >> /etc/resolv.conf <<-EOF
#  domain $TLD
#  search $TLD
#  nameserver 127.0.0.1
#  nameserver 62.141.32.5
#  nameserver 62.141.32.4
#  nameserver 62.141.32.3
#  nameserver 8.8.8.8
#EOF


# check if everything is running:
service fastd restart
service isc-dhcp-server restart
ln -s /etc/puppet/modules/ffnord/files/usr/local/bin/check-services /root/check-services
