# Install scripts for a Freifunk Nord Gateway


### 1. copy this file to the root home folder:

    cp mesh_peerings.yaml /root/

### 2. create the file with the fastd private key

    echo 'secret "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";' > /root/fastd_secret.key

### 3. copy this file to the root home folder:

    cp manifest.pp /root/gateway.pp
and adapt all needed settings to the new gateway

#### 4. start the pre, puppet and post script

    ./pre-puppet.sh

follow instructions at the end of the script. **make sure you are in a screen session**

    screen
    puppet apply --verbose /root/gateway.pp
    # start puppet again in case something went wrong:
    puppet apply --verbose /root/gateway.pp
    build-firewall
    bash post-puppet.sh

#### local exit without VPN

    We do the following steps for ivp4 only, ipv6 is not forwarded locally.
    First is the runtime change and after that instructions to change the startup
    configuration.

    Enable maintenance mode,

    > maintenance on
    
    after DHCPLEASETIME stop openvpn and disable startup on boot.

    > service openvpn stop
    > update-rc.d openvpn disable 

    Remove the ip-rule "from all iif br-ffki unreachable".

    > ip rule del pref 31001

    Remove matchings lines from /etc/network/interfaces.d/ffnord-bridge,
    remove post-up and post-down line. In the next step we assume that the
    wan interface is named "eth0". Add following
    to /etc/iptables.d/800-mesh-forward-ACCEPT-eth0

    ip4tables -A mesh-forward -o eth0 -j ACCEPT

    and following to /etc/iptables.d/910-Masquerade-eth0
    
    ip4tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

    , then rerun firewall setup.

    > build-firewall

    This will do the job for the network part. In the next step we have to modify
    the runtime in a way that it will not panic when no tun-anonvpn is available
    and enter maintenance.

    > ip link add name tun-anonvpn type dummy

    Add the same line into /etc/rclocal.d/dummy-anonvpn-iface. Now leave maintenance
    and return to normal operation.

    > maintenance off && service ntp start && batctl -m bat-ffnord gw server 100/100 && check-services

    Now the supernode should forward traffic directly. Make sure that you have disabled the check-gateway scripts and other vpn watchdogs in your crontabs

