#!/bin/bash

unzip -d Fortify Fortify.zip
sudo cp Fortify/ssc.war /opt/tomcat/apache-tomcat-8.5.29/webapps/
sudo tomcatdown
sleep 30
sudo tomcatup
