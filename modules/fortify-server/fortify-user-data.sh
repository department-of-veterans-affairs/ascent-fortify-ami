#!/bin/bash

# ##########################################
# Acquire fortify license from s3 bucket
# ##########################################
aws s3api get-object --bucket ascent-fortify --key fortify.license --region us-gov-west-1 fortify.license
sudo mv /fortify.license /root/.fortify/fortify.license

# ##########################################
# Do some configuration stuff for fortify
# ##########################################
fortify_config_properties=/root/.fortify/ssc/conf/app.properties
fortify_data_properties=/root/.fortify/ssc/conf/datasource.properties
fortify_ip=`hostname -I`

# The variables below are filled in via Terraform interpolation
sed -i "s|^host.url=|host.url=http://$fortify_ip:8080/ssc|g" $fortify_config_properties
sed -i 's|^jdbc.url=|jdbc.url=${fortify_jdbc_url}|g' $fortify_data_properties
sed -i 's|^db.driver.class=|db.driver.class=${fortify_db_driver_class}|g' $fortify_data_properties
sed -i 's|^db.username=|db.username=${fortify_db_username}|g' $fortify_data_properties
sed -i 's|^db.password=|db.password=${fortify_db_password}|g' $fortify_data_properties

# #########################################
# Start Fortify
# #########################################
sudo tomcatup
