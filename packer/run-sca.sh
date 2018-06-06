#!/bin/bash
set -e

echo "*******************************************************************"
source ~/.bash_profile
echo "MAVEN_HOME=$MAVEN_HOME"
echo "MAVEN_VERSION=$MAVEN_VERSION"
echo "JAVA_HOME=$JAVA_HOME"
echo "*******************************************************************"

# ##########################################
# Acquire fortify license from s3 bucket
# ##########################################
aws s3api get-object --bucket fortify-utlity --key fortify.license --region us-gov-west-1 fortify.license
sudo cp /fortify.license /root/.fortify/fortify.license


echo "Installing sca.."
sudo cp /fortify.license /opt/fortify_sca/fortify.license
sudo /opt/fortify_sca/HPE_Security_Fortify_SCA_and_Apps_17.20_linux_x64.run --mode unattended


echo "Creating sym links..."
FORTIFY_APPS=/opt/HPE_Security/Fortify_SCA_and_Apps_17.20
FORTIFY_APPS_BIN=$FORTIFY_APPS/bin
FORTIFY_MVN_PLUGIN=$FORTIFY_APPS/plugins/maven/
BIN=/usr/bin

sudo ln -s $FORTIFY_APPS_BIN/fortifyclient $BIN/fortifyclient
sudo ln -s $FORTIFY_APPS_BIN/scapostinstall $BIN/scapostinstall
sudo ln -s $FORTIFY_APPS_BIN/fortifyupdate $BIN/fortifyupdate
sudo ln -s $FORTIFY_APPS_BIN/FPRUtility $BIN/FPRUtility
sudo ln -s $FORTIFY_APPS_BIN/sourceanalyzer $BIN/sourceanalyzer
sudo ln -s $FORTIFY_APPS_BIN/ReportGenerator $BIN/ReportGenerator


echo "Downloading all of the latest rule packs...."
sudo fortifyupdate

echo "Installing the fortify maven plugin..."
sudo mkdir -p /opt/fortify-maven-plugin
sudo unzip -d /opt/fortify-maven-plugin  $FORTIFY_MVN_PLUGIN/maven-plugin-src.zip
cd /opt/fortify-maven-plugin
sudo mvn clean install

echo "done!"
echo ""
echo ""
