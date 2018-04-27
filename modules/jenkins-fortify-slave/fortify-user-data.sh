#!/bin/bash


# The following variables are replaced with terraform interpolation
/home/ec2-user/run-sca-jenkins-node.sh ${jenkins_password} \
                                       ${jenkins_user} \
                                       ${jenkins_url} \
                                       ${fortify_ssh_password} \
                                       ${fortify_ssh_user} \
                                       ${agent-name} \
                                       "${agent-description}" \
                                       ${agent-label-name} \
                                       ${credentials_id} \
                                       > /home/ec2-user/run-sca-jenkins-node.out 2>&1
