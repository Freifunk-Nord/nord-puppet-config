#!/bin/bash
#https://github.com/ffnord/ffnord-puppet-gateway

VPN_NUMBER=1
DOMAIN="freifunknord.net"
TLD=ffnord
IP6PREFIX=fd42:eb49:c0b5:4242

sed -i 's/( //;s/ )//g' /etc/ffnord

# firewall config
build-firewall

#fastd ovh config
cd /etc/fastd/ffnord-mvpn/
git clone https://github.com/Freifunk-Nord/nord-gw-peers-public backbone
touch /usr/local/bin/update-fastd-gw
cat <<-EOF>> /usr/local/bin/update-fastd-gw
#!/bin/bash

cd /etc/fastd/ffnord-mvpn/backbone
git pull -q
EOF
chmod +x /usr/local/bin/update-fastd-gw

# check if everything is running:
check-services
echo 'maintenance off if needed !'
echo 'adapt hostname in the OVH-template /etc/cloud/templates/hosts.debian.tmpl and reboot'
