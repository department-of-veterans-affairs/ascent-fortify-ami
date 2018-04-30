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


echo "Creating a jenkins agent..."
#########################################
# Set variables and output for
# debugging purposes
#########################################
JENKINS_PASSWORD=$1
JENKINS_USER=$2
JENKINS_URL=$3
FORTIFY_SSH_PASSWORD=$4
FORTIFY_SSH_USER=$5
agent_name=$6
agent_description=$7
agent_label_name=$8
credentials_id=$9

export node_ip_address=`hostname -I | xargs`

echo "JENKINS_PASSWORD=${JENKINS_PASSWORD}"
echo "JENKINS_USER=${JENKINS_USER}"
echo "JENKINS_URL=${JENKINS_URL}"
echo "FORTIFY_SSH_PASSWORD=${FORTIFY_SSH_PASSWORD}"
echo "FORTIFY_SSH_USER=${FORTIFY_SSH_USER}"
echo "agent_name=${agent_name}"
echo "agent_description=${agent_description}"
echo "agent_label_name=${agent_label_name}"
echo "node_ip_address=${node_ip_address}"
echo "credentials_id=${credentials_id}"

echo "###################################"
echo "Create host user for jenkins"
echo "###################################"
echo "- ADD USER ${FORTIFY_SSH_USER}"
sudo useradd ${FORTIFY_SSH_USER}
echo "- SET PASSWORD *******"
echo "${FORTIFY_SSH_PASSWORD}" | passwd $FORTIFY_SSH_USER --stdin

echo "- TURN ON PASSWORD AUTHENTICATION"
sudo sed -i -e "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config

echo "- RESTARTING sshd"
sudo service sshd restart

echo "- TURNING OFF TTY FOR ${FORTIFY_SSH_USER} USER"
printf 'Defaults:"'"${FORTIFY_SSH_USER}"'" !requiretty\n' | EDITOR='tee -a' visudo

echo "- TURNING OFF NOPASSWD FOR WHEEL"
sudo sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers

echo "- DONE"
echo ""
echo ""
echo "###################################"
echo "ADD AS A NODE TO JENKINS"
echo "###################################"
echo "- DOWNLOADING slave.jar"
wget ${JENKINS_URL}/jnlpJars/slave.jar
sudo mv ./slave.jar /home/$FORTIFY_SSH_USER/slave.jar
sudo chown $FORTIFY_SSH_USER:$FORTIFY_SSH_USER /home/$FORTIFY_SSH_USER/slave.jar

echo "- HAVE JENKINS ADD ME AS A NODE"
echo "getting crumb..."
API_TOKEN=$(curl -u ${JENKINS_USER}:${JENKINS_PASSWORD} ${JENKINS_URL}/me/configure | sed -rn 's/.*id="apiToken"[^>]*value="([a-z0-9]+)".*/\1/p')
CRUMB=$(curl -s -u ${JENKINS_USER}:${API_TOKEN} "${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")

echo "add node..."
curl -i -H $CRUMB -L -s -X POST -u ${JENKINS_USER}:${API_TOKEN} -d 'json={"name": "'"${agent_name}"'", "nodeDescription": "'"${agent_description}"'", "numExecutors": "1", "remoteFS": "/home/jenkins", "labelString": "'"${agent_label_name}"'", "mode": "EXCLUSIVE", "": ["hudson.plugins.sshslaves.SSHLauncher", "hudson.slaves.RetentionStrategy$Always"], "launcher": {"stapler-class": "hudson.plugins.sshslaves.SSHLauncher", "$class": "hudson.plugins.sshslaves.SSHLauncher", "host": "'"${node_ip_address}"'", "credentialsId": "'"${credentials_id}"'", "port": "22", "javaPath": "", "jvmOptions": "", "prefixStartSlaveCmd": "", "suffixStartSlaveCmd": "", "launchTimeoutSeconds": "", "maxNumRetries": "", "retryWaitTime": ""}, "retentionStrategy": {"stapler-class": "hudson.slaves.RetentionStrategy$Always", "$class": "hudson.slaves.RetentionStrategy$Always"}, "nodeProperties": {"stapler-class-bag": "true"}}' "${JENKINS_URL}/computer/doCreateItem?name=${agent_name}&type=hudson.slaves.DumbSlave"
