#!/bin/bash
#https://github.com/ffnord/ffnord-puppet-gateway
# adapt IPV6 first!
# do dpkg-reconfigure tzdata

NAME="Freifunk Nord"
OPERATOR="Freifunk Nord"
CHANGELOG="https://bug.freifunk.net/projects/ffnord-admin"
HOST_PREFIX="nord-"
SUBDOMAIN_PREFIX=vpn
VPN_NUMBER=4
DOMAIN="nord.freifunk.net"
SUDOUSERNAME="debian"
TLD=ffnord

#backborts einbauen
echo "deb http://http.debian.net/debian jessie-backports main" >>/etc/apt/sources.list

#sysupgrade
apt-get update && apt-get dist-upgrade && apt-get upgrade

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
#echo "127.0.1.1 $SUBDOMAIN_PREFIX$VPN_NUMBER.$DOMAIN $HOST_PREFIX$VPN_NUMBER" >>/etc/hosts
rm /etc/hostname
touch /etc/hostname
echo "$HOST_PREFIX$VPN_NUMBER" >>/etc/hostname

# install needed packages
apt-get -y install sudo apt-transport-https git

# optional pre installed to speed up the setup:
apt-get -y install bash-completion haveged sshguard tcpdump mtr-tiny vim nano unp mlocate screen tmux cmake build-essential libcap-dev pkg-config libgps-dev python3 ethtool lsb-release zip locales-all ccze ncdu

#not needed packages from standard OVH template
apt-get -y remove nginx nginx-full exim mutt

#puppet modules install
apt-get -y install --no-install-recommends puppet
puppet module install puppetlabs-stdlib --version 4.15.0 && \
puppet module install puppetlabs-apt --version 1.5.1 && \
puppet module install puppetlabs-vcsrepo --version 1.3.2 && \
puppet module install saz-sudo --version 4.1.0 && \
puppet module install torrancew-account --version 0.1.0
cd /etc/puppet/modules
git clone https://github.com/ffnord/ffnord-puppet-gateway ffnord

# symlink check-install script
ln -s /etc/puppet/modules/ffnord/files/usr/local/bin/check-services /usr/local/bin/check-services

# add aliases
cat <<-EOF>> /root/.bashrc
  export LS_OPTIONS='--color=auto'
  eval " \`dircolors\`"
  alias ls='ls \$LS_OPTIONS'
  alias ll='ls \$LS_OPTIONS -lah'
  alias l='ls \$LS_OPTIONS -lA'
  alias grep="grep --color=auto"
  # let us only use aptitude on gateways
  alias apt-get='sudo aptitude'
  alias ..="cd .."
EOF

# back in /root
cd /root

echo load the ip_tables and ip_conntrack module
modprobe ip_conntrack
echo ip_conntrack >> /etc/modules

#SSH config
rm /etc/ssh/sshd_config
cp /opt/nord-puppet-config/sshd_config /etc/ssh/sshd_config
service sshd restart

cat <<-EOF>> ~/.ssh/config
Host gitlab.com
HostName gitlab.com
Port 22
User root
IdentityFile ~/.ssh/ffnord-gitlab.rsa
EOF

#online script
touch /usr/local/bin/online
cat <<-EOF>> /usr/local/bin/online
#!/bin/bash

maintenance off && service ntp start && batctl -m bat-ffnord gw server 100/100 && check-services
EOF
chmod +x /usr/local/bin/online

#OVH network config
cat <<-EOF>> /etc/network/interfaces

iface eth0 inet6 static
       address
       netmask 128
       post-up /sbin/ip -6 route add 2001:41d0:401:2100::1 dev eth0
       post-up /sbin/ip -6 route add default via 2001:41d0:401:2100::1 dev eth0
       pre-down /sbin/ip -6 route del default via 2001:41d0:401:2100::1 dev eth0
       pre-down /sbin/ip -6 route del 2001:41d0:401:2100::1 dev eth0

auto eth1
allow-hotplug eth1
iface eth1 inet dhcp
EOF


#USER TODO:
echo 'now copy the files manifest.pp and mesh_peerings.yaml to /root and make sure /root/fastd_secret.key exists'
echo 'adapt IPV6 adress'
echo '####################################################################################'
echo '########### don´t run the following scripts without screen sesssion!!! #############'
echo '####################################################################################'
cat $(dirname $0 )/README.md
