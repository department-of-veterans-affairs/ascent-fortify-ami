#!/bin/bash

# -- check if aws exists and fail if it doesn't
type aws >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed. Aborting."; exit 1; }

# -- Download Fortify server
aws s3api get-object --bucket ascent-fortify --key HPE_Security_Fortify_17.20_Server_WAR_Tomcat.zip  Fortify.zip

# -- Download Fortify license
aws s3api get-object --bucket ascent-fortify --key fortify.license fortify.license



packer build fortify.json

