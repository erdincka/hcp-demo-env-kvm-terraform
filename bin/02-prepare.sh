#!/usr/bin/env bash

terraform output -json | jq '[].'