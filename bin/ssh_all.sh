#!/usr/bin/env bash

IPs=$(terraform output -json | jq ' .[].value | .[] | .[] ')
echo ${IPs}

# parallel-ssh -H root@${IPs} ${1}
