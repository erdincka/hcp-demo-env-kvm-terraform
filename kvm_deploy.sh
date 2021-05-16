#!/usr/bin/env bash
set -eu 

echo "Checking pre-requisites..."
./bin/00-initenv.sh

echo "Creating resources for deployment..."
./bin/01-create.sh

echo "Setting up the resources for installation..."
./bin/02-prepare.sh

echo "Starting installation on controller..."
./bin/03-install.sh

