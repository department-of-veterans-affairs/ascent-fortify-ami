#!/bin/bash

sudo echo "export MAVEN_VERSION=3.3.9" | sudo tee -a /home/ec2-user/.bash_profile
sudo echo 'export MAVEN_HOME=/usr/local/apache-maven-${MAVEN_VERSION}' | sudo tee -a /home/ec2-user/.bash_profile
source /home/ec2-user/.bash_profile

echo "#######################################################################"
echo "**** .bash_profile ****"
echo "JAVA_HOME=$JAVA_HOME"
echo "MAVEN_VERSION=$MAVEN_VERSION"
echo "MAVEN_HOME=$MAVEN_HOME"
echo "#######################################################################"



sudo curl -s -L -o apache-maven-${MAVEN_VERSION}-bin.tar.gz http://mirror.jax.hugeserver.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz; \
    tar xzvf apache-maven-${MAVEN_VERSION}-bin.tar.gz; \
    sudo mv apache-maven-${MAVEN_VERSION} ${MAVEN_HOME}; \
    sudo rm -rf apache-maven-${MAVEN_VERSION}-bin.tar.gz; \
    sudo ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn;
