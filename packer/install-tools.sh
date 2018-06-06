#!/bin/bash

# Update
sudo yum -y update --quiet

# Install uzip utility
sudo yum -y install unzip --quiet

# Install rpm-build for SCA stuff
sudo yum install -y rpm-build --quiet
