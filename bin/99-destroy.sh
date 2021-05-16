#!/usr/bin/env bash

ssh-keygen -R $(terraform output -json | jq -cr .controller_ip.value[0][0]) > /dev/null

terraform destroy -var-file=./etc/main.tfvars --auto-approve
