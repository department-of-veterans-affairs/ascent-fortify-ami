#!/bin/bash

unzip -d Fortify Fortify.zip
sudo cp Fortify/ssc.war /opt/tomcat/apache-tomcat-8.5.30/webapps/

# Download connector and move to appropriate location
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.zip
unzip mysql-connector-java-5.1.46.zip
chmod 755 mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar
sudo mv /home/ec2-user/setenv.sh /opt/tomcat/apache-tomcat-8.5.30/bin/
sudo chmod 755 /opt/tomcat/apache-tomcat-8.5.30/bin/setenv.sh

sudo tomcatdown
sleep 5

# wait for tomcat to be fully up before continuing so that 
# fortify war file can 'explode'
sudo /home/ec2-user/wait_for_tomcat_up.sh
