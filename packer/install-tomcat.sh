#!/bin/bash
set -e
TOMCAT_BIN=/opt/tomcat/apache-tomcat-8.5.30/bin
sudo mkdir -p /opt/tomcat/ && cd /opt/tomcat 
sudo wget http://mirrors.ibiblio.org/apache/tomcat/tomcat-8/v8.5.30/bin/apache-tomcat-8.5.30.zip

sudo unzip apache-tomcat-8.5.30.zip
cd $TOMCAT_BIN
sudo chmod 700 $TOMCAT_BIN/*.sh

sudo ln -s $TOMCAT_BIN/startup.sh /usr/bin/tomcatup
sudo ln -s $TOMCAT_BIN/shutdown.sh /usr/bin/tomcatdown

sudo tomcatup
sleep 30

