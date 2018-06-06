#!/bin/bash
APACHE_LOG_DIR=/opt/tomcat/apache-tomcat-8.5.31/logs
keepgoing=0
echo "moving existing logs somewhere else..."
if [ -f $APACHE_LOG_DIR/catalina.out ]; then
   timestamp=`date +"%m%d_%H%M"`
   sudo mv $APACHE_LOG_DIR/catalina.out $APACHE_LOG_DIR/catalina.$timestamp
fi
sudo tomcatup

echo "waiting for tomcat..."
sleep 5
while [ $keepgoing -ne 1 ]; do
  output_ready=`sudo cat $APACHE_LOG_DIR/catalina.out | grep "Server startup"`
  if [ -z "$output_ready" ]; then
     echo -n "."
     sleep 5
  else 
     echo "Tomcat up."
     keepgoing=1
  fi
done

