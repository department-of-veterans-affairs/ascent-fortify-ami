#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Install sca onto the host
/home/ec2-user/run-sca.sh

# The following variables are replaced with terraform interpolation
/home/ec2-user/run-register-jenkins-node.sh "${jenkins_password}" \
                                       "${jenkins_user}" \
                                       "${jenkins_url}" \
                                       "${fortify_ssh_password}" \
                                       "${fortify_ssh_user}" \
                                       "${agent-name}" \
                                       "${agent-description}" \
                                       "${agent-label-name}" \
                                       "${credentials_id}" \
                                       "${vault_url}"
