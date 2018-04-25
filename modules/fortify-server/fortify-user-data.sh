#!/bin/bash

# The following variables are replaced with terraform interpolation
/home/ec2-user/run-fortify-ssc.sh ${fortify_db_name} ${fortify_jdbc_url} ${fortify_db_driver_class} ${fortify_db_username} ${fortify_db_password} ${fortify_db_endpoint} ${root_db_name}> /home/ec2-user/run-fortify-ssc.out 2>&1

/home/ec2-user/run-sca.sh > /home/ec2-user/run-sca.out 2>&1

