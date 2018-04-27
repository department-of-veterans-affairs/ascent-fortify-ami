#!/bin/bash
set -e

echo "Packer building an ami..."
packer build -var-file=./settings.json fortify.json

