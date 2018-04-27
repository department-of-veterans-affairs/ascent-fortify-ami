#!/bin/bash

wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
sudo yum install -y bzip2

tar -xvf phantomjs-2.1.1-linux-x86_64.tar.bz2
cd phantomjs-2.1.1-linux-x86_64/bin
sudo cp phantomjs /usr/bin

sudo yum install -y fontconfig freetype libfreetype.so.6 libfontconfig.so.1 libstdc++.so.6

