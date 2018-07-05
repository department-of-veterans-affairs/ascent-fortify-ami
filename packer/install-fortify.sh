#!/bin/bash

# Download the Fortify SCA app from S3 and prep for install
aws s3api --region us-gov-west-1 get-object --bucket fortify-utility --key HPE_Security_Fortify_SCA_and_Apps_17.20_Linux.tar.gz Fortify_SCA.tar.gz
sudo mkdir -p /opt/fortify_sca
sudo tar -xzf /home/ec2-user/Fortify_SCA.tar.gz -C /opt/fortify_sca
sudo mv fortify-sca.options /opt/fortify_sca/

# Make the run-*.sh scripts executable
chmod 755 /home/ec2-user/run-*.sh
