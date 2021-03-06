class { 
 'ffnord::params':
  router_id      => "10.187.5.1", # The id of this router, probably the ipv4 address
                                  # of the mesh device of the providing community
  icvpn_as       => "65187",      # The as of the providing community
  wan_devices    => ['eth0'],     # An array of devices which should be in the wan zone
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
  , mesh_mac        => "fe:ed:be:ef:ff:01"
  , vpn_mac         => "fe:ed:be:ff:ff:01"
  , mesh_ipv6       => "fd42:eb49:c0b5:4242::fd01/64"
  , mesh_ipv4       => "10.187.5.1/17"
  , range_ipv4      => "10.187.0.0/16"
  , mesh_mtu        => "1280"
  , mesh_peerings   => "/root/mesh_peerings.yaml"
 
  , fastd_secret    => "/root/nord-gw1-fastd-secret.key"
  , fastd_port      => 10050
  , fastd_peers_git => 'git@gitlab.com:ffnord/nord-ffffng-keys.git'
 
  , dhcp_ranges     => ['10.187.5.2 10.187.8.254']
  , dns_servers     => ['10.187.5.1'] # should be the same as $router_id
}

class {'ffnord::vpn::provider::pia':
  openvpn_server    => "germany.privateinternetaccess.com",
  openvpn_port      => 3478,
  openvpn_user      => "xxxxxxx",
  openvpn_password  => "xxxxxxxx";
}

ffnord::named::zone {
  "nord": zone_git => "https://github.com/Freifunk-Nord/nord-zone-bat15.git", exclude_meta => 'nord';
}

class {
  ['ffnord::etckeeper','ffnord::rsyslog','ffnord::alfred']:
}

# Useful packages
package {
  ['vim','tcpdump','dnsutils','realpath','screen','htop','mlocate','tig']:
     ensure => installed;
}
