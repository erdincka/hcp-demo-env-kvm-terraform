#!usr/bin/env bash
set -eu

wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y -q epel-release-latest-7.noarch.rpm || echo "Ignoring error installing epel"
if [[ -e /home/centos/bd_installed ]]
then
  echo BlueData already installed - quitting
  exit 0
fi

wget -c --progress=bar -e dotbytes=1M https://dl.google.com/go/go1.13.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz
if [[ ! -d minica ]];
then
  git clone https://github.com/jsha/minica.git
  cd minica/
  /usr/local/go/bin/go build
  sudo mv minica /usr/local/bin
fi

cd ~
wget -c --progress=bar -e dotbytes=10M -O ${epic_filename} "${epic_url}"
chmod +x ${epic_filename}
./${epic_filename} --skipeula --default-password admin123
touch /home/centos/bd_installed

# KERB_OPTION="-k no"
# if [[ "$EMBEDDED_DF" == "True" ]]; then
#   LOCAL_TENANT_STORAGE=""
# else
#   LOCAL_TENANT_STORAGE="--no-local-tenant-storage"
# fi
# LOCAL_FS_TYPE=""
# WORKER_LIST=""
# CLUSTER_IP=""
# HA_OPTION=""
# PROXY_LIST=""
# FLOATING_IP="--routable no"
# DOMAIN_NAME="demo.bdlocal"
# CONTROLLER_IP="-c ${CONFIG_CONTROLLER_IP}"
# CUSTOM_INSTALL_NAME="--cin demo-hpecp"
# /opt/bluedata/common-install/scripts/start_install.py \$CONTROLLER_IP \
#   \$WORKER_LIST \$PROXY_LIST \$KERB_OPTION \$HA_OPTION \
#   \$FLOATING_IP -t 60 -s docker -d \$DOMAIN_NAME \$CUSTOM_INSTALL_NAME \$LOCAL_TENANT_STORAGE