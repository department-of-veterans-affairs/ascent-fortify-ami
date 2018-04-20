#!/bin/bash

# Download Fortify zip file from S3
aws s3api --region us-gov-west-1 get-object --bucket ascent-fortify --key HPE_Security_Fortify_17.20_Server_WAR_Tomcat.zip  Fortify.zip

# Download the Fortify SCA app from S3 and prep for install
aws s3api --region us-gov-west-1 get-object --bucket ascent-fortify --key HPE_Security_Fortify_SCA_and_Apps_17.20_Linux.tar.gz Fortify_SCA.tar.gz
sudo mkdir -p /opt/fortify_sca
sudo tar -xzf /home/ec2-user/Fortify_SCA.tar.gz -C /opt/fortify_sca
sudo mv fortify-sca.options /opt/fortify_sca/

unzip -d Fortify Fortify.zip
sudo cp Fortify/ssc.war /opt/tomcat/apache-tomcat-8.5.30/webapps/

# Download connector and move to appropriate location
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.zip
unzip mysql-connector-java-5.1.46.zip
chmod 755 mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar
sudo mv /home/ec2-user/setenv.sh /opt/tomcat/apache-tomcat-8.5.30/bin/
sudo chmod 755 /opt/tomcat/apache-tomcat-8.5.30/bin/setenv.sh

# For some odd reason, this always errors out and says that tomcat is not running at localhost,
# .. but it comes down anyway.
sudo tomcatdown
sleep 5

# wait for tomcat to be fully up before continuing so that 
# fortify war file can 'explode'
sudo /home/ec2-user/wait_for_tomcat_up.sh


# Download Seed Bundles from S3
aws s3api --region us-gov-west-1 get-object --bucket ascent-fortify --key HP_Fortify_Process_Seed_Bundle-2017_Q3.zip HP_Fortify_Process_Seed_Bundle-2017_Q3.zip
aws s3api --region us-gov-west-1 get-object --bucket ascent-fortify --key HP_Fortify_Report_Seed_Bundle-2017_Q3.zip HP_Fortify_Report_Seed_Bundle-2017_Q3.zip


# Make the run-*.sh scripts executable
chmod 755 /home/ec2-user/run-*.sh

