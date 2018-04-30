#!/bin/bash

# Install sca onto the host
/home/ec2-user/run-sca.sh > /home/ec2-user/run-sca.out 2>&1

# The following variables are replaced with terraform interpolation
/home/ec2-user/run-register-jenkins-node.sh ${jenkins_password} \
                                       ${jenkins_user} \
                                       ${jenkins_url} \
                                       ${fortify_ssh_password} \
                                       ${fortify_ssh_user} \
                                       ${agent-name} \
                                       "${agent-description}" \
                                       ${agent-label-name} \
                                       ${credentials_id} \
                                       > /home/ec2-user/run-register-jenkins-node.out 2>&1
