#!/usr/bin/env bash

set -ev

# First update system
yum -y update

# Get and install salt
curl -L https://bootstrap.saltstack.com -o install_salt.sh
# Install salt minion from latest stable
sh install_salt.sh -F -Z -P -X stable

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

file_roots:
  base:
    - /srv/salt/states
pillar_roots:
  base:
    - /srv/salt/pillar

# Configuration specifique au minion
backup_mode: minion
retry_dns: 30
acceptance_wait_time_max: 2
log_level: info
log_datefmt: '%H:%M:%S'
mine_functions:
  test.ping: []
  network.ip_addrs:
    interface: eth0
    cidr: '10.0.0.0/8'
EOF


# Clone and checkout states
yum -y install git
mkdir /srv && cd /srv
git clone https://github.com/WeScale/handson-salt.git /srv/salt

# Start services
systemctl start salt-minion

# Prepare motd
IP=$(curl -s -H "Metadata-Flavor:Google" http://metadata/computeMetadata/v1/instance/network-interfaces/0/ip)
echo "WeScale - Welcome to $HOSTNAME ($IP)" > /etc/motd

