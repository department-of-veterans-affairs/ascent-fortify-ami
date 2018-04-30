#!/bin/bash
set -e

# ##########################################
# Acquire fortify license from s3 bucket
# ##########################################
aws s3api get-object --bucket ascent-fortify --key fortify.license --region us-gov-west-1 fortify.license
sudo cp /fortify.license /root/.fortify/fortify.license


echo "Installing sca.."
sudo cp /fortify.license /opt/fortify_sca/fortify.license
sudo /opt/fortify_sca/HPE_Security_Fortify_SCA_and_Apps_17.20_linux_x64.run --mode unattended


echo "Creating sym links..."
FORTIFY_APPS_BIN=/opt/HPE_Security/Fortify_SCA_and_Apps_17.20/bin
BIN=/usr/bin

sudo ln -s $FORTIFY_APPS_BIN/fortifyclient $BIN/fortifyclient
sudo ln -s $FORTIFY_APPS_BIN/scapostinstall $BIN/scapostinstall
sudo ln -s $FORTIFY_APPS_BIN/fortifyupdate $BIN/fortifyupdate
sudo ln -s $FORTIFY_APPS_BIN/FPRUtility $BIN/FPRUtility
sudo ln -s $FORTIFY_APPS_BIN/sourceanalyzer $BIN/sourceanalyzer
echo "done!"
echo ""
echo ""
