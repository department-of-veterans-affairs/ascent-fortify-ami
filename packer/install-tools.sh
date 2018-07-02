#!/bin/bash

# Update
sudo yum -y update --quiet

# Install uzip and git utilities
sudo yum -y install git unzip --quiet

# Install rpm-build for SCA stuff
sudo yum install -y rpm-build --quiet
