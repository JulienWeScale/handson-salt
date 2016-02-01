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

cat << EOT > /etc/motd
                                                                                                 .*/////////////////*,.
                                                                                             ,////////////////////////////*
                                                                                         .////////////////////////////////////,
                                                                                       /////////////////////////////////////////*
                                                                                    .//////////////////////////////////////////////
                                                                                   /////////////////////////////////////////////////*
                                                                                 *////////////////////////////////////////////////////
                                                                                ///////////////////////////////////////////////////////
                                                                               /////////////////////////////////////////////////////////
                                                                              */////////////////////////////////////////////////////////
                                                                             .//////////////////////////////////////////////////////////  /////*.
                                                                             /////////////////////////////////////////////////////////// ///////////,
                                                                             //////////////////////////////////////////(@@@@@@@////////,///////////////*
                                                                  .*///////////////////////////////////////////////////(@@@@@@@(/////////////////////////*
                                                             .////////////////////////////////////////////////////////////&@@@@(///////////////////////////.
                                                          .///////////////////////////////////////////////////////////////&@@@@(////////////////////////////*
,,,,.      ,,,,,,      ,,,,,      .,,,,,,,,,,           ////////%@@@@@@@@@&(////////(&@@@@@@@@@#//////(@@@@@@@@@@&(///////&@@@@(///////#@@@@@@@@@&////////////
,,,,,     .,,,,,,     .,,,,,    ,,,,,,,,,,,,,,,        ///////%@@@@@@@@@@@@@@/////@@@@@@@@@@@@@@@%///@@@@@@@@@@@@@@@#/////&@@@@(/////&@@@@@@&&@@@@@@#/////////*
,,,,,,    ,,,,,,,,    ,,,,,,  .,,,,,,,   ,,,,,,,.    .///////(@@@@&/////@@@@@(//&@@@@@@(/////@@@@@//(@@@@#/////#@@@@@(////&@@@@(////@@@@@///////@@@@@%/////////
 ,,,,,    ,,,,,,,,    ,,,,,  .,,,,,,       ,,,,,,    ////////(@@@@&////////////&@@@@@////////(@@@@//////////////&@@@@&////&@@@@(///@@@@&/////////&@@@@(////////
 ,,,,,,  ,,,,,,,,,   ,,,,,   ,,,,,,,,,,,,,,,,,,,,,  */////////@@@@@@@@&(///////@@@@@/////////////////////(&&@@@@@@@@@@////&@@@@(//&@@@@@@@@@@@@@@@@@@@&////////
  ,,,,,  ,,,,,,,,,,  ,,,,,   ,,,,,,,,,,,,,,,,,,,,,  ////////////@@@@@@@@@@@(//(@@@@&/////////////////#@@@@@@@@@@@@@@@@////&@@@@(//&@@@@@@@@@@@@@@@@@@@&////////
  ,,,,,  ,,,,  ,,,, ,,,,,    ,,,,,.                 ///////////////(@@@@@@@@@(/@@@@@///////////////(@@@@@///////%@@@@@////&@@@@(//&@@@@(///////////////////////
   ,,,,,,,,,,  ,,,, ,,,,,    ,,,,,,                 ///////////////////(@@@@@@/@@@@@&//////////////@@@@@////////@@@@@@////&@@@@(//(@@@@@///////////////////////
   ,,,,,,,,,   ,,,,,,,,,      ,,,,,,,        .,,     /////////&@@#//////#@@@@@//@@@@@@@(//////%@@@(@@@@@@#///(@@@@@@@@////&@@@@#///(@@@@@@#//////(&@@//////////
    ,,,,,,,,    ,,,,,,,,       ,,,,,,,,,,,,,,,,,,    ////////@@@@@@@@@@@@@@@@(///#@@@@@@@@@@@@@@@@@/@@@@@@@@@@@@#@@@@@@@(/&@@@@@@@///@@@@@@@@@@@@@@@@@(///////
    ,,,,,,,,    ,,,,,,,          ,,,,,,,,,,,,,,,      /////////#@@@@@@@@@@@#////////&@@@@@@@@@@@(////#@@@@@@@@@//@@@@@@@(/(@@@@@@@/////#@@@@@@@@@@@&/////////
     ,,,,,,     ,,,,,,,             ,,,,,,,,,          /////////////////////////////////////////////////////////////////////////////////////////////////////
                                                         /////////////////////////////////////////////////////////////////////////////////////////////////
                                                            //////////////////////////////////////////////////////////////////////////////////////////(
 WeScale - Welcome to $HOSTNAME ($IP)
EOT


# Create user wescale with authorized_keys and sudo
useradd --create-home wescale
# wescale should be sudoer
echo 'wescale ALL=NOPASSWD: ALL' >> /etc/sudoers
mkdir -p /home/wescale/.ssh
cat << EOP > /home/wescale/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCSf88x3h5YTt4iyUdQZkfy6CTe0S04HYN1Y1IhJv34kjUki0Ch3XC9xpspu+CyxDun0WTZ2r1k/HUp0kJ3JnMAmRq/32M6x+S59cBy4zCuSyC56iEEEh02qVSWTach7sRbrz/6E8+KLcykdj5qMlNZFPeZY30532Lizz6Uz1TmQU5UVghaTHGlMAKu4DGg9XRXtVM2ef/AUi0jQKgykL7UE+46jVSxciTroZKqujV5LtxxP5kJZy98icNzGPFfBKSpN2YntYeCzQnw8N+Vsct+iZ+FJkTVNBU/+VzyOkwjyRGzlaDCFMQheHi31G89FhQtAFkX7TNi7+Y1Q/5OGmJ slemesle@MacBook-Pro-de-Seven.local
EOP
chmod 600 /home/wescale/.ssh/authorized_keys
chown -R wescale:wescale /home/wescale/.ssh


# Fire an event to notify minion is up
salt-call event.send 'minion/bootstrap/done' data="{\"id\": \"${HOSTNAME}\"}" with_grains="roles"

