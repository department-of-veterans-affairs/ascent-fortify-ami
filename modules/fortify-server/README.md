# Fortify Server

This folder contains a [Terraform](https://www.terraform.io/) module that can be used to deploy a [Fortify SSC](https://software.microfocus.com/en-us/products/software-security-assurance-sdlc/overview) V17.20 server with its database in [AWS](https://aws.amazon.com/). This module is designed to deploy an [Amazon Machine Image (AMI)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) that had Fortify SSC installed via the [packer scripts](https://github.com/department-of-veterans-affairs/ascent-fortify-ami/tree/master/packer) in this project.

## How do you use this module?
This folder defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your code by adding a `module` configuration and setting its `source` parameter to URL of this folder:

```
module "fortify" {
  # Use version 1.1 of the fortify-server module
  source                      = "github.com/department-of-veterans-affairs/ascent-fortify-ami.git//modules/fortify-server?ref=v1.1"

  # The name of the fortify instance.
  instance_name               = "Fortify SSC"

  # Specify the ID of the Fortify AMI. You should build this using the scripts in the packer folder of this project.
  ami_id                      = "ami-abc12345"

  # ... See variables.tf for the all other required parameters as well as the optional ones
}
```
Note the following parameter:
- `source`: Use this parameter to specify the URL of the fortify-server module. The double slash (//) is intentional and required. Terraform uses it to specify subfolders within a Git repo (see module sources). The ref parameter specifies a specific Git tag in this repo. That way, instead of using the latest version of this module from the master branch, which will change every time you run Terraform, you're using a fixed version of the repo.

You can find the other parameters in [variables.tf](https://github.com/department-of-veterans-affairs/ascent-fortify-ami/blob/master/modules/fortify-server/variables.tf)

## What's included in this module?
This architecture consists of the following resources:
- [Security Group](#security-group)
- [IAM role and permissions](#iam-role-and-permissions)
- [AWS RDS Instance](#aws-rds-instance)
- [AWS RDS subnet group](#aws-rds-subnet-group)
- [AWS RDS DB parameter group](#aws-rds-db-parameter-group)

### Security Group
The Fortify EC2 Instance has a Security Group that allows:
- All outbound requests
- Inbound requests from specified [CIDR blocks](https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html) to Fortify SSC's web access port (default 8080)
- Inbound requests from specified security group ids to Fortify SSC's web access port (default 8080)
- Inbound requests from specified CIDR blocks to Fortify's ssh port (default 22)

The [AWS RDS Instance](#AWS RDS Instance) has a Security Group that allows:
- Inbound requests from a specified security group ID (default the Fortify SSC security group ID)

### IAM role and permissions
The Fortify SSC instance has an [IAM Role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) attached that grants the Fortify SSC read access to an [S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingBucket.html).

### AWS RDS Instance
In addition to the Fortify SSC instance, an [Amazon RDS Instance](https://aws.amazon.com/rds/) is also launched with a [MySQL](https://www.mysql.com/) database engine (default version set to 5.6). With all [parameter groups](#AWS RDS DB parameter group) that the [Fortify SSC Installation Guide](https://community.softwaregrp.com/t5/Fortify-Software-17-20/Fortify-Static-Code-Analyzer-Installation-Guide/ta-p/1622562) requires.

### AWS RDS subnet group
[List of subnet group IDs](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html#USER_VPC.Subnets) for the AWS RDS to be deployed into. Used to have high availability.


### AWS RDS DB parameter group
The MySQL database engine does not automatically have all of the settings required to support the database that Fortify SSC needs. It has to have the following configs (the defaults are what is suggested by the [SSC Installation Manual](https://community.softwaregrp.com/t5/Fortify-Software-17-20/Fortify-Static-Code-Analyzer-Installation-Guide/ta-p/1622562)):

| Setting Type | Default |
| ------------ | ------:|
| max_allowed_packet | 1073741824  (1G)|
| innodb_log_file_size | 3221225472 (3G)|
| innodb_lock_wait_timeout | 300 |
| query_cache_type | 1 |
| query_cache_size | 73400320 (70M) |
| innodb_buffer_pool_size | 10737418240 (10G)|
| innodb_file_format | Barracuda |
| innodb_large_prefix | 1 |

## How do you roll out updates?
A simple solution for this is yet to be discovered, as Fortify SSC's updates require for all data to be rebuilt manually, and all projects with scans to be imported (which is also a manual process).

## What's NOT included in this module?
This module does NOT handle the following items, which you may want to provide on your own:
- [Monitoring, alerting, log aggregation](#monitoring-alerting-log-aggregation)
- [VPCs, subnets, route tables](#vpcs-subnets-route-tables)

### Monitoring, alerting, log aggregation
This module does not include anything for monitoring, alerting, or log aggregation. All EC2 Instances come with limited CloudWatch metrics built-in, but beyond that, you will have to provide your own solutions. We have an on going solution for implementing Prometheus, but that is still a work in progress


### VPCs, subnets, route tables
This module assumes you've already created your network topology (VPC, subnets, route tables, etc). You will need to pass in the the relevant info about your network topology (e.g. `vpc_id`, `subnet_ids`) as input variables to this module.
