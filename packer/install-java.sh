#! /bin/bash
set -e

JAVA_FILE=jdk1.8.0_171

# Install Java Runtime
curl -L -H "Cookie: oraclelicense=accept-securebackup-cookie" -o $JAVA_FILE.tar.gz "http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz"
tar -xzf $JAVA_FILE.tar.gz
rm $JAVA_FILE.tar.gz
sudo mkdir -p /usr/lib/jvm
sudo mv $JAVA_FILE /usr/lib/jvm/$JAVA_FILE
sudo chown -R root:root /usr/lib/jvm/$JAVA_FILE

sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/$JAVA_FILE/bin/java 1200
