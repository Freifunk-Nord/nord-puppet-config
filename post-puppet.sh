#!/bin/bash
#https://github.com/ffnord/ffnord-puppet-gateway

VPN_NUMBER=0
DOMAIN=nord.freifunk.net
TLD=ffnord
IP6PREFIX=2a03:2267:4e6f:7264

#NGINX, if needed to serve the firmware for the auto-updater
#apt-get install -y nginx

#mkdir /opt/www
#sed s~"usr/share/nginx/www;"~"opt/www;"~g -i /etc/nginx/sites-enabled/default

#DNS Server
sed -i .bak "/eth0 inet static/a \  dns-search vpn$VPN_NUMBER.$DOMAIN" >>/etc/network/interfaces

rm /etc/resolv.conf
cat >> /etc/resolv.conf <<-EOF
  domain $TLD
  search $TLD
  nameserver 127.0.0.1
  nameserver 62.141.32.5
  nameserver 62.141.32.4
  nameserver 62.141.32.3
  nameserver 8.8.8.8
EOF

mv /etc/radvd.conf /etc/radvd.conf.bak
cat >> /etc/radvd.conf << EOF
# managed for interface br-$TLD
interface br-$TLD
{
 AdvSendAdvert on;
 AdvDefaultLifetime 0; # New
 IgnoreIfMissing on;
 MaxRtrAdvInterval 200;

 prefix $IP6PREFIX:0000:0000:0000:0000/64
 {
   AdvPreferredLifetime 14400; # New
   AdvValidLifetime 86400; # New
 };
 prefix fdda:fee6:0187:0000:0000:0000:0000:0000/64
  {
    AdvPreferredLifetime 14400; # New
    AdvValidLifetime 86400; # New
  };
 RDNSS $IP6PREFIX::fd0$VPN_NUMBER
 {
 };

 route fc00::/7  # this block
 {
   AdvRouteLifetime 1200;
 };
};
EOF
cp /etc/radvd.conf /etc/radvd.conf.d/interface-br-$TLD.conf

# check if everything is running:
service fastd restart
service isc-dhcp-server restart
check-services
