class { 
 'ffnord::params':
  router_id      => "10.187.100.1", # The id of this router, probably the ipv4 address
                                  # of the mesh device of the providing community
  icvpn_as       => "65187",      # The as of the providing community
  wan_devices    => ['ens18'],     # An array of devices which should be in the wan zone
  wmem_default   => 87380,        # Define the default socket send buffer
  wmem_max       => 12582912,     # Define the maximum socket send buffer
  rmem_default   => 87380,        # Define the default socket recv buffer
  rmem_max       => 12582912,     # Define the maximum socket recv buffer
  
  gw_control_ips => "8.8.8.8", # Define target to ping against for function check
  max_backlog    => 5000, # Define the maximum packages in buffer
  include_bird4  => false,
  maintenance    => 1,
  batman_version => 15,
}

ffnord::mesh { 
 'mesh_ffnord':
    mesh_name       => "Freifunk Nord"
  , mesh_code       => "ffnord"
  , mesh_as         => "65187"
  , mesh_mac        => "fe:ed:be:ef:ff:30"
  , vpn_mac         => "fe:ed:be:ff:ff:30"
  , mesh_ipv6       => "fd42:eb49:c0b5:4242::fd30/64"
  , mesh_ipv4       => "10.187.100.1/17"
  , range_ipv4      => "10.187.0.0/16"
  , mesh_mtu        => "1312"
  , mesh_peerings   => "/opt/nord-puppet-config/mesh_peerings.yaml"
 
  , fastd_secret    => "/root/nord-1-hypergw-fastd-secret.key"
  , fastd_port      => 10050
  , fastd_peers_git => 'https://github.com/Freifunk-Nord/nord-gw-peers-public'
 
  , dhcp_ranges     => ['10.187.100.2 10.187.120.254']
  , dns_servers     => ['10.187.100.1'] # should be the same as $router_id
}

ffnord::named::zone {
  "nord": zone_git => "https://github.com/Freifunk-Nord/nord-zone-bat15.git", exclude_meta => 'nord';
}

ffnord::icvpn::setup {
  'nordhypergw1':
  icvpn_as               => 65187,
  icvpn_ipv4_address     => "10.207.11.12",
  icvpn_ipv6_address     => "fec0::a:cf:b:c",
  icvpn_exclude_peerings => [nord],
  tinc_keyfile           => "/root/nord-1-hypergw-icvpn-rsa_key.priv"
}

class {
  ['ffnord::etckeeper','ffnord::rsyslog']:
}

# Useful packages
package {
  ['vim','tcpdump','dnsutils','realpath','screen','htop','mlocate','tig']:
     ensure => installed;
}
