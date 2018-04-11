#!/bin/bash

# Acquire fortify license from s3 bucket
aws s3api get-object --bucket ascent-fortify --key fortify.license fortify.license
sudo mv ./fortify.license /root/.fortify/fortify.license

# The variables below are filled in via Terraform interpolation
sudo tomcatup
