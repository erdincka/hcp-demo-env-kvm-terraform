#!/usr/bin/env bash

function fail {
  echo $1
  exit 1
}

# Check pre-requisites
command -v ssh-keygen >/dev/null 2>&1 || fail >&2 "I require 'ssh-keygen' but it's not installed. Aborting."
command -v terraform >/dev/null 2>&1  || { 
    echo >&2 "I require 'terraform' but it's not installed.  Aborting."
    fail >&2 "Please install as per: https://learn.hashicorp.com/terraform/getting-started/install.html"
}

# create id key files if not exist
ssh_file=$(grep -E '^ssh_prv_key_path' ./etc/main.tfvars | cut -d'"' -f2)
[ -f $ssh_file ] || ssh-keygen -q -t rsa -N '' -b 2048 -f "${ssh_file}"

# Test passwordless ssh access
HOST=$(grep -E "^libvirt_uri =" ./etc/main.tfvars | cut -d'/' -f3)
# echo $HOST

if [ -z ${HOST} ]
then 
  echo "Running on localhost"
  CONNECT=""
  sudo -n true
else
  echo "Running on remote host: ${HOST}"
  CONNECT="ssh -q -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 ${HOST} "
  $CONNECT 'exit 0'
fi
if [ $? == '0' ]; then
  echo "sudo ok"
else
  [ -z "${HOST}" ] && fail "Please run ssh-copy-id ${HOST}" || fail "Please edit sudoers file for passwordless sudo, and try again"
fi

# Check SE enforcement for libvirt (Ubuntu only)
REL=$($CONNECT lsb_release -is)
if [ $REL == "Ubuntu" ]
then
  drv=$($CONNECT sudo grep -E '^security_driver' /etc/libvirt/qemu.conf | cut -d'"' -f2)
  if [ $drv != "none" ]; then
    fail "need to set security_driver to none"
  fi
fi

