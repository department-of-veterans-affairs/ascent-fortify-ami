# Fortify Database
This folder contains a [Terraform](https://www.terraform.io/) module that can be used to deploy an [AWS RDS Instance](https://aws.amazon.com/rds/). This is useful if you need a [MySQL](https://www.mysql.com/) database that's provisioned with everything needed for a [Fortify SSC](https://software.microfocus.com/en-us/products/software-security-assurance-sdlc/overview) server.

## How do you use this module?
This folder defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html) which you can use in your code by adding a module configuration and setting its source parameter to URL of this folder:

```
module "fortify-database" {
  # Use version 1.1 of the fortify-database module
  source                               = "github.com/department-of-veterans-affairs/ascent-fortify-ami.git//modules/fortify-database?ref=v1.1"

  # ... See variables.tf file for more required parameters
}
```
Note the following parameter:
- `source`: Use this parameter to specify the URL of the fortify-database module. The double slash (//) is intentional and required. Terraform uses it to specify subfolders within a Git repo (see module sources). The ref parameter specifies a specific Git tag in this repo. That way, instead of using the latest version of this module from the master branch, which will change every time you run Terraform, you're using a fixed version of the repo.

## What's included in this module?
- [Security Group](#security-group)
- [AWS RDS Instance](#aws-rds-instance)
- [AWS RDS subnet group](#aws-rds-subnet-group)
- [AWS RDS DB parameter group](#aws-rds-db-parameter-group)

### Security Group
The [AWS RDS Instance](#aws-rds-instance) has a Security Group that allows:
- Inbound requests from a specified security group ID (default the Fortify SSC security group ID)

### AWS RDS Instance
A [Amazon RDS Instance](https://aws.amazon.com/rds/) is launched with a [MySQL](https://www.mysql.com/) database engine (default version set to 5.6). With all [parameter groups](#AWS RDS DB parameter group) that the [Fortify SSC Installation Guide](https://community.softwaregrp.com/t5/Fortify-Software-17-20/Fortify-Static-Code-Analyzer-Installation-Guide/ta-p/1622562) requires.

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
