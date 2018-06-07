#!/bin/bash

ANT_HOME=/opt/apache-ant-1.10.3
ANT_FILE=apache-ant-1.10.3-bin.tar.gz
ANT_TASKS=maven-ant-tasks-2.1.3.jar
# -- A list of mirrors to try to download from
mirrors=( http://apache.claz.org//ant/binaries/$ANT_FILE
          http://apache.cs.utah.edu//ant/binaries/$ANT_FILE
          http://apache.mirrors.ionfish.org//ant/binaries/$ANT_FILE
          http://apache.mirrors.lucidnetworks.net//ant/binaries/$ANT_FILE
        )

echo "------ DOWNLOADING ANT BINARY"
#  -- Try the list of mirrors until we hit one that works
for i in "${mirrors[@]}"
do
   :
      if wget $i ; then
        break
      else
        echo "==> Mirror ${i} failed. Trying other mirror..."
      fi
done

# -- Fail the script if the ant zip file wasn't downloaded
if [ ! -f $ANT_FILE ]; then
  echo "==> FAILURE: all mirrors failed."
  exit 1
fi

sudo mkdir -p /opt/
sudo tar xvzf $ANT_FILE -C /opt/
sudo ln -s ${ANT_HOME}/bin/ant /usr/bin/ant;

sudo echo 'export PATH=$PATH:"'"${ANT_HOME}/bin"'"' | sudo tee -a /home/ec2-user/.bash_profile
sudo echo 'export ANT_HOME="'"${ANT_HOME}"'"' | sudo tee -a /home/ec2-user/.bash_profile
source /home/ec2-user/.bash_profile
echo "############################################################################################################"
echo "******** Contents of .bash_profile"
echo "ANT_HOME=$ANT_HOME"
echo "PATH=$PATH"
echo "############################################################################################################"

echo "------- DOWNLOADING MAVEN ANT TASKS"
wget http://www.apache.org/dyn/closer.cgi/maven/binaries/$ANT_TASKS
sudo mv $ANT_TASKS $ANT_HOME/lib

echo "------- INSTALLATIONS DONE! checking to see if it's installed properly...."
ant -version
