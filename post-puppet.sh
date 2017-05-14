#!/bin/bash
#https://github.com/ffnord/ffnord-puppet-gateway

VPN_NUMBER=4
DOMAIN=nord.freifunk.net
TLD=ffnord
IP6PREFIX=fd42:eb49:c0b5:4242

#NGINX, if needed to serve the firmware for the auto-updater
#apt-get install -y nginx

#mkdir /opt/www
#sed s~"usr/share/nginx/www;"~"opt/www;"~g -i /etc/nginx/sites-enabled/default

#DNS Server
# Dies Knallte bei OVH:
# sed -i .bak "/eth0 inet static/a \  dns-search vpn$VPN_NUMBER.$DOMAIN" /etc/network/interfaces

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

# alfred make install fix
#cd /opt/alfred
#make install CONFIG_ALFRED_CAPABILITIES=n

# alfred fix for /bin/sh
sed -i 's/( //;s/ )//g' /etc/ffnord
service alfred restart
cd
puppet apply --verbose $VPN_NUMBER.gateway.pp
sed -i 's/( //;s/ )//g' /etc/ffnord

# firewall config
build-firewall

# check if everything is running:
check-services
echo maintenance off if needed !
echo adapt hostname in the OVH-template /etc/cloud/templates/hosts.debian.tmpl and reboot
echo add ipv6 to  /etc/network/interfaces, for example:
echo '
iface eth0 inet6 static
       address https://github.com/Freifunk-Nord/nord-puppet-config
       netmask 128
       post-up /sbin/ip -6 route add 2001:41d0:401:2100::1 dev eth0
       post-up /sbin/ip -6 route add default via 2001:41d0:401:2100::1 dev eth0
       pre-down /sbin/ip -6 route del default via 2001:41d0:401:2100::1 dev eth0
       pre-down /sbin/ip -6 route del 2001:41d0:401:2100::1 dev eth0
'
