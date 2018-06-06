#!/bin/bash
set -e
TOMCAT_BIN=/opt/tomcat/apache-tomcat-8.5.31/bin
sudo mkdir -p /opt/tomcat/ && cd /opt/tomcat 
sudo wget http://www.gtlib.gatech.edu/pub/apache/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.zip

sudo unzip apache-tomcat-8.5.31.zip
cd $TOMCAT_BIN
sudo chmod 700 $TOMCAT_BIN/*.sh

sudo ln -s $TOMCAT_BIN/startup.sh /usr/bin/tomcatup
sudo ln -s $TOMCAT_BIN/shutdown.sh /usr/bin/tomcatdown

sudo chmod 755 /home/ec2-user/wait_for_tomcat_up.sh
sudo /home/ec2-user/wait_for_tomcat_up.sh

