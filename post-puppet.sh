#!/bin/bash
#https://github.com/ffnord/ffnord-puppet-gateway

VPN_NUMBER=4
DOMAIN=nord.freifunk.net
TLD=ffnord
IP6PREFIX=fd42:eb49:c0b5:4242

# alfred fix for /bin/sh
sed -i 's/( //;s/ )//g' /etc/ffnord
service alfred restart
cd
puppet apply --verbose $VPN_NUMBER.gateway.pp
sed -i 's/( //;s/ )//g' /etc/ffnord

#OVH VRACK iptables config
sed -i 's/wan-input/wan-input -i eth0/g' /etc/iptables.d/500-Allow-fastd-ffnord
echo "ip46tables -A wan-input -i eth1 -p udp -m udp --dport 10050 -j ACCEPT -m comment --comment 'fastd-ffnord'" >>/etc/iptables.d/500-Allow-fastd-ffnord

# firewall config
build-firewall

#fastd ovh config
cd /etc/fastd/ffnord-mvpn/
git clone https://github.com/Freifunk-Nord/nord-gw-peers-ovh
touch /usr/local/bin/update-fastd-gw
cat <<-EOF>> /usr/local/bin/update-fastd-gw
#!/bin/bash

cd /etc/fastd/ffnord-mvpn/nord-gw-peers-ovh
git pull -q
EOF
chmod +x /usr/local/bin/update-fastd-gw

#online script
touch /usr/local/bin/online
cat<<-EOF>> /usr/local/bin/online
#!/bin/bash

maintenance off && service ntp start && batctl -m bat-ffnord gw server 100/100 && check-services
EOF
chmod +x /usr/local/bin/online

# check if everything is running:
check-services
echo 'maintenance off if needed !'
echo 'adapt hostname in the OVH-template /etc/cloud/templates/hosts.debian.tmpl and reboot'
echo 'add "include peers from "nord-gw-peers-ovh";" to fastd.conf'
