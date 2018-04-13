#!/bin/bash
set -e

echo "Checking if aws exists"
type aws >/dev/null 2>&1 || { printf "\xE2\x9D\x8C   aws cli probably not installed. Aborting..."; exit 1; }

echo ""
if [ ! -f Fortify.zip ]; then
    echo "Fortify.zip not found. Downloading..."
    aws s3api get-object --bucket ascent-fortify --key HPE_Security_Fortify_17.20_Server_WAR_Tomcat.zip  Fortify.zip
    echo "Done."
fi
echo ""

echo "Packer building an ami..."
packer build -var-file=./settings.json fortify.json

