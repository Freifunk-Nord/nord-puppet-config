class { 'ffnord::params':
  router_id => "10.187.$$$.$$$",
  icvpn_as => "65187",
  wan_devices => ['eth0'],
  include_bird4 => false,
  maintenance => 0,
  #debian_mirror => "http://repo.myloc.de/mirrors/ftp.de.debian.org/debian/";
}
# aus https://github.com/ffnord/site-nord/blob/master/site.conf
# und https://github.com/freifunk/icvpn-meta/blob/master/nord
ffnord::mesh { 'mesh_ffnord':
        mesh_name => "Freifunk Nord"
      , mesh_code => "ffnord"
      , mesh_as => "65187"
      , mesh_mac  => "fe:ed:be:ef:ff:$$"
      , vpn_mac  => "fe:ed:be:ff:ff:$$"
      , mesh_ipv6 => "2a03:2267:4e6f:7264::fd$$/64"
      , mesh_ipv4  => "10.187.$$$.$$$/17"
      , range_ipv4 => "10.187.0.0/16"
      , mesh_mtu     => "1280"
      , mesh_peerings    => "/root/mesh_peerings.yaml"

      , fastd_secret => "/root/nord-gw$$-fastd-secret.key"
      , fastd_port   => 10050
      , fastd_peers_git => 'https://github.com/Freifunk-Nord/nord-gw-peers.git'

      , dhcp_ranges => ['10.187.$$$.2 10.187.$$$.254'] 
      , dns_servers => ['10.187.$$$.1']
}

class {'ffnord::vpn::provider::hideio':
  openvpn_server => "$$$",
  openvpn_port   => 3478,
  openvpn_user   => "$$$",
  openvpn_password => "$$$";
}

ffnord::named::zone {
  "nord": zone_git => "https://github.com/Freifunk-Nord/nord-zone.git", exclude_meta => 'nord';
}

ffnord::icvpn::setup {
                'nordgw$$':
                icvpn_as => 65187,
                icvpn_ipv4_address => "10.207.$$$.$$$",
                icvpn_ipv6_address => "fec0::a:cf:$$$:$$$",
                icvpn_exclude_peerings     => [Nord],
                tinc_keyfile       => "/root/nord-vpn$$-icvpn-rsa_key.priv"
}

class {
  ['ffnord::etckeeper','ffnord::rsyslog','ffnord::alfred']:
}

#class {
#  'ffnord::monitor::nrpe':
#     allowed_hosts => "217.70.197.95";
#}
#class {
#  'ffnord::monitor::zabbix':
#    zabbixserver => "5.9.51.89";
#}

# Useful packages
package {
  ['vim','tcpdump','dnsutils','realpath','screen','htop','mlocate','tig']:
     ensure => installed;
}
