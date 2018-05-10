#!/bin/bash

# ##########################################
# Set all of the commandline variables
# supplied from fortify-user-data.sh
# ##########################################
NUMBER_CLI_ARGS=8

# Check that we have the right amount of args
if [ "$#" -ne $NUMBER_CLI_ARGS ]; then
    echo "Usage: run-fortify-ssc.sh [fortify_db_name] [fortify_jdbc_url] [fortify_db_driver_class] [fortify_db_username] [fortify_db_password] [fortify_db_endpoint] [root_db_name]"
    exit 1
fi

# Actually set the variables here
fortify_db_name=$1
fortify_jdbc_url=$2
fortify_db_driver_class=$3
fortify_db_username=$4
fortify_db_password=$5
fortify_db_endpoint=$6
root_db_name=$7
fortify_dns=$8


# Output the variables for debugging
echo "fortify_db_name=$fortify_db_name"
echo "fortify_jdbc_url=$fortify_jdbc_url"
echo "fortify_db_driver_class=$fortify_db_driver_class"
echo "fortify_db_username=$fortify_db_username"
echo "fortify_db_password=$fortify_db_password"
echo "fortify_db_endpoint=$fortify_db_endpoint"
echo "root_db_name=$root_db_name"
echo "fortify_dns=$fortify_dns"


# ##########################################
# Acquire fortify license from s3 bucket
# ##########################################
aws s3api get-object --bucket ascent-fortify --key fortify.license --region us-gov-west-1 fortify.license
sudo cp /fortify.license /root/.fortify/fortify.license

# ##########################################
# Do some configuration stuff for fortify
# ##########################################
fortify_config_properties=/root/.fortify/ssc/conf/app.properties
fortify_data_properties=/root/.fortify/ssc/conf/datasource.properties

sed -i "s|^host.url=|host.url=http://$fortify_dns:8080/ssc|g" $fortify_config_properties
sed -i 's|^host.validation=false|host.validation=true|g' $fortify_config_properties
sed -i "s|^jdbc.url=|jdbc.url=$fortify_jdbc_url?connectionCollation=latin1_general_cs|g" $fortify_data_properties
sed -i "s|^db.driver.class=|db.driver.class=$fortify_db_driver_class|g" $fortify_data_properties
sed -i "s|^db.username=|db.username=$fortify_db_username|g" $fortify_data_properties
sed -i "s|^db.password=|db.password=$fortify_db_password|g" $fortify_data_properties

# #########################################
# Start Fortify
# #########################################
sudo tomcatup


# #########################################
# Populate database with create-tables.sql
# #########################################
fortify_endpoint_no_port=`echo ${fortify_db_endpoint} | cut -d: -f1`

echo "[create-ssc-db.sql]"
mysql -u ${fortify_db_username} -p${fortify_db_password} -h $fortify_endpoint_no_port ${root_db_name} < /home/ec2-user/create-ssc-db.sql
echo "done!"
echo "[create-tables.sql]"
mysql -u ${fortify_db_username} -p${fortify_db_password} -h $fortify_endpoint_no_port ${fortify_db_name} < /home/ec2-user/Fortify/sql/mysql/create-tables.sql
echo "done!"

# #########################################
# Do Fortify Wizard setup
# #########################################
keepgoing=0
while [ $keepgoing -eq 0 ]; do
   if [ -f /root/.fortify/ssc/init.token ]; then
       keepgoing=1
       echo "init.token found. continue execution"
   else
       echo "No init.token yet. sleeping...."
       sleep 5
   fi
done


# --- replace the DATABASE_USERNAME and DATABASE_PASSWORD in phantomjs script
sed -i "s/DATABASE_USERNAME/$fortify_db_username/g" /home/ec2-user/setupFortify.js
sed -i "s/DATABASE_PASSWORD/$fortify_db_password/g" /home/ec2-user/setupFortify.js

sudo cp /root/.fortify/ssc/init.token /home/ec2-user/init.token
echo "Setting up ssc..."
sudo phantomjs /home/ec2-user/setupFortify.js
echo "done!"


# ##############################################
# Restart Fortify for changes to take effect
# ##############################################
sudo tomcatdown

sleep 5

sudo tomcatup
