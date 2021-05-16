#!/usr/bin/env bash

terraform apply -var-file=./etc/main.tfvars -auto-approve
