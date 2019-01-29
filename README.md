![Fortify Logo](https://github.com/department-of-veterans-affairs/ascent-fortify-ami/blob/doc-revamp/fortify-logo.png)
# Fortify AWS Module

This repo contains a Module for how to deploy Fortify utility servers on AWS using [Terraform](https://www.terraform.io/). Fortify is a licensed distribution that performs security scans on your code. By default, Fortify SSC uses a MySQL database as the storage backend for scans, suppressions, etc.

This Module includes:
- **s3-bucket-policies-to-role**: As Fortify is a paid distribution, it is necessary to download any software and licensing from an [AWS S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/user-guide/create-configure-bucket.html) to the EC2 instance on which Fortify SSC is hosted. The EC2 Instance, then, should be created with a [role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-service.html) attached to it with the S3 bucket policies as defined by this module.
- **jenkins-fortify-slave**: This module creates and configures an EC2 Instance to run as a jenkins slave performing source scans using various Fortify tools such as sourceanalyzer and FPRUtility.
- **jenkins-node-security-group-rules**: The security group rules needed for the jenkins fortify slave instance to route to the Jenkins Master instance.

## What's a Module?
Modules in Terraform are self-contained packages of Terraform configurations that are managed as a group. Modules are used to create reusable components in Terraform as well as for basic code organization. A **root module** is the current working directory when you run `terraform apply` or get, holding the Terraform configuration files. It is itself a valid module. The root module in this project is **jenkins-fortify-slave**. See [https://www.terraform.io/docs/modules/usage.html] for more details for creating your own module.

## Prerequisites
- [Terraform](https://www.terraform.io/intro/getting-started/install.html)
- [Packer](https://www.packer.io/docs/install/index.html)
- An active [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)
- A valid Fortify license and Fortify software uploaded to an Amazon S3 bucket
  * **Bucket Name**: utility-fortify
  * **Software Key**: HPE_Security_Fortify_17.20_Server_WAR_Tomcat.zip
  * **SCA and Utilities Key**: HPE_Security_Fortify_SCA_and_Apps_17.20_Linux.tar.gz
  * **License Key**: fortify.license
  * **Region**: us-gov-west-1

  *(TODO: Need to make all of these parameterized and filled in via template rendering in terraform)*
- [A Jenkins Master server](https://jenkins.io/download/)


## How do you use this Module?
This Module has the following folder structure:
- [modules](https://github.com/department-of-veterans-affairs/ascent-fortify-ami/tree/master/modules): This folder contains the reusable code for this Module, broken down into one or more modules.
- [packer](https://github.com/department-of-veterans-affairs/ascent-fortify-ami/tree/master/packer): This folder contains all of the scripts necessary to create an [AWS AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) that has the capabilities to create a Fortify SSC server or a Fortify Jenkins Slave.


##### To Deploy Fortify Jenkins Slave
1. Create an AMI that has Fortify SCA and Apps installed (using the [packer scripts](https://github.com/department-of-veterans-affairs/ascent-fortify-ami/tree/master/packer))
2. Setup your Jenkins Master for the slave to connect to
3. Deploy your AMI from Step 1 in a private subnet and register it to the Jenkins Master instance using the Terraform [jenkins-fortify-slave](https://github.com/department-of-veterans-affairs/ascent-fortify-ami/tree/master/modules/jenkins-fortify-slave) module.
