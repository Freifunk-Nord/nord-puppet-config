# Install scripts for a Freifunk Nordheide Gateway
## First, make shure your system is debian jessie, system ist up to date. git has to be installed.
## a screen session is required. 

### 1. copy this file to the root home folder:
    cp mesh_peerings.yaml /root/

### 2. create the file with the fastd private key
    echo 'secret "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";' > /root/fastd_secret.key

### 3. copy this file to the root home folder:
    cp manifest.pp /root/gateway.pp
and adapt all needed settings to the new gateway

### 4. change dir to /opt dir
    cd /opt
    
### 5. clone nordheide-puppet-config
    git clone https://github.com/freifunk-nordheide/nordheide-puppet-config

### 6. change dir to /opt/nordheide-puppet-config
    cd nordheide-puppet-config

### 7. start the pre-puppet script
    sh pre-puppet.sh
    
### 8. change dir back to /etc/puppet/modules/ffnord
    cd /etc/puppet/modules/ffnord
    
### 9. check out jessie branch of the puppet-script
    git checkout jessy-support
    
### 10. change dir back to /opt/nordheide-puppet-config
    cd /opt/nordheide-puppet-config
    
### 11. run the puppet-script
    puppet apply --verbose manifest.pp
    
### 12. start the post-puppet-script
    sh post-puppet.sh
    
### 13. build the firewall
    build-firewall
    
### 14. resart the vpn connection
    <service openvpn restart
    
### 15. edit /etc/ffnord and insert an known pingable host. eg 8.8.8.8 @ GW_CONTROL_IP
    nano /etc/ffnord
    
### 16. exit maintenance mode
    maintenance off
    
### 17. run checkgateway script. if it returns without an error, dudue, you're done with this job!!!
    check-gateway

#### 18. create addtitional user and garant root to them

    adduser newuser
    adduser newuser sudo
