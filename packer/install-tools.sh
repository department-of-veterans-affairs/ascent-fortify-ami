#!/bin/bash

# Update
sudo yum -y update --quiet

# Install uzip utility
sudo yum -y install unzip --quiet

# Install rpm-build for SCA stuff
sudo yum install -y rpm-build --quiet

# install mysql client to run the create-tables.sql script on database
wget https://dev.mysql.com/get/Downloads/MySQL-5.5/MySQL-client-5.5.59-1.el7.x86_64.rpm
sudo yum localinstall -y MySQL-client-5.5.59-1.el7.x86_64.rpm --quiet
sudo yum install -y MySQL-client --quiet
