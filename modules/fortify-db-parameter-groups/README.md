# Fortify DB Parameter groups
This folder contains a [Terraform](https://www.terraform.io/) module that can be used to configure an [AWS RDS Instance](https://aws.amazon.com/rds/). This is useful if you need to have an existing RDS instance with a MySQL engine configured with all settings suggested by the [Fortify SSC Installation Guide](https://community.softwaregrp.com/t5/Fortify-Software-17-20/Fortify-Static-Code-Analyzer-Installation-Guide/ta-p/1622562).

## How do you use this module?
This folder defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html) which you can use in your code by adding a module configuration and setting its source parameter to URL of this folder:

```
module "parameter_group" {
  # Use version 1.1 of the fortify-database module
  source  = "github.com/department-of-veterans-affairs/ascent-fortify-ami.git//modules/fortify-db-parameter-groups?ref=v1.1"

  # A Name for the parameter group
  name   = "My Cool Fortify Database Parameter Group"

  # A parameter group family
  family = "mysql${var.mysql_version}"
}
```

Note the following parameters:
- `source`: Use this parameter to specify the URL of the fortify-db-parameter-groups module. The double slash (//) is intentional and required. Terraform uses it to specify subfolders within a Git repo (see module sources). The ref parameter specifies a specific Git tag in this repo. That way, instead of using the latest version of this module from the master branch, which will change every time you run Terraform, you're using a fixed version of the repo.
- `name`: A name for the database parameter group.
- `family`: The family for the parameter group. Usually comes in the form of {engine_type}{engine-version}. Only known way to get the value of the family is to go to the RDS console -> Parameter Groups -> Create Parameter Group -> Parameter group family drop down menu to see a list. ** *Make sure that the parameter group family matches the engine and version* **

## What's included in this module?
- [AWS RDS DB parameter group](#aws-rds-db-parameter-group)


### AWS RDS DB parameter group
The configs are the suggested/required setting that the [SSC Installation Manual](https://community.softwaregrp.com/t5/Fortify-Software-17-20/Fortify-Static-Code-Analyzer-Installation-Guide/ta-p/1622562) has for the MySQL database engine. The manual says to edit the mysql.cnf to fix the configurations, but as we don't have admin access into the rds instance itself, we use a parameter group instead and have AWS handle actually configuring the database for us. The following are reasonable defaults:

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


## What's NOT included in this module?
This module does NOT handle the following items, which you may want to provide on your own:
- [AWS RDS Instance](#aws-rds-instance)
- [Monitoring, alerting, log aggregation](#monitoring-alerting-log-aggregation)
- [VPCs, subnets, route tables](#vpcs-subnets-route-tables)

### AWS RDS Instance
This module does not include an AWS RDS Instance, and it is not meant to. To associate this parameter group with your RDS instance, use the `parameter_group_name` output of this module for your RDS's `parameter_group_name` value. If you were configuing your RDS resource, you would associate this parameter group by doing (assuming you've named this module `my_awesome_parameter_group`):
```
parameter_group_name   = "${module.my_awesome_parameter_group.parameter_group_name}"
```


### Monitoring, alerting, log aggregation
This module does not include anything for monitoring, alerting, or log aggregation. All EC2 Instances come with limited CloudWatch metrics built-in, but beyond that, you will have to provide your own solutions. We have an on going solution for implementing Prometheus, but that is still a work in progress


### VPCs, subnets, route tables
This module assumes you've already created your network topology (VPC, subnets, route tables, etc). You will need to pass in the the relevant info about your network topology (e.g. `vpc_id`, `subnet_ids`) as input variables to this module.
