#!/usr/bin/env bash
agent_name=$1
JENKINS_USER=$2
JENKINS_PASSWORD=$3
JENKINS_URL=$4

echo "- HAVE JENKINS REMOVE NODE ${agent_name}"
echo "getting crumb..."
API_TOKEN=$(curl -u ${JENKINS_USER}:${JENKINS_PASSWORD} ${JENKINS_URL}/me/configure | sed -rn 's/.*id="apiToken"[^>]*value="([a-z0-9]+)".*/\1/p')
CRUMB=$(curl -s -u ${JENKINS_USER}:${API_TOKEN} "${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")

curl -i -H $CRUMB -L -s -X POST -u ${JENKINS_USER}:${API_TOKEN} http://jenkins.internal.vets-api.gov:8080/computer/${agent_name}/doDelete
