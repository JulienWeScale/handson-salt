#!/usr/bin/env bash

set -ev

# First update system
yum -y update

# Get and install salt
curl -L https://bootstrap.saltstack.com -o install_salt.sh
# Install salt master/minion/syndic from latest stable
sh install_salt.sh -F -S -Z -P -M -X stable

# Retrieve and set Grains
GRAINS=$(curl -s -H "Metadata-Flavor:Google" http://metadata/computeMetadata/v1/instance/attributes/grains)
echo "${GRAINS}" > /etc/salt/grains

# Configure Minion
MASTER=$(curl -s -H "Metadata-Flavor:Google" http://metadata/computeMetadata/v1/instance/attributes/master)
HOSTNAME=$(hostname | tr -d "\n")

mkdir -p /etc/salt/minion.d
cat <<EOF > /etc/salt/minion.d/minion.conf
id: ${HOSTNAME}
master: ${MASTER}

# Configuration specifique au minion
backup_mode: minion
retry_dns: 30
acceptance_wait_time_max: 2
log_level: info
log_datefmt: '%H:%M:%S'
EOF

# Configure Master
mkdir -p /etc/salt/master.d
cat <<EOF > /etc/salt/master.d/master.conf
auto_accept: True
order_masters: True
pillar_safe_render_error: False
file_roots:
  base:
    - /srv/salt/states
pillar_roots:
  base:
    - /srv/salt/pillar
EOF

if [ ${MASTER} != 'localhost' ]; then
    # Configure syndication
    cat <<EOF > /etc/salt/master.d/syndic.conf
########################################################################################################################
##  Syndic configuration

# this master where to receive commands from.
syndic_master: ${MASTER}

# This is the 'ret_port' of the MasterOfMaster:
syndic_master_port:  4506

# PID file of the syndic daemon:
#syndic_pidfile: /var/run/salt-syndic.pid

# LOG file of the syndic daemon:
syndic_log_file: syndic.log
EOF
    systemctl start salt-syndic
else
    sysctl -w net.ipv4.ip_forward=1
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
fi

# Clone and checkout states
yum -y install git
mkdir /srv && cd /srv
git clone https://github.com/WeScale/handson-salt.git /srv/salt

# Start services
systemctl start salt-master
systemctl start salt-minion

# Prepare motd
IP=$(curl -s -H "Metadata-Flavor:Google" http://metadata/computeMetadata/v1/instance/network-interfaces/0/ip)
echo "WeScale - Welcome to $HOSTNAME ($IP)" > /etc/motd

