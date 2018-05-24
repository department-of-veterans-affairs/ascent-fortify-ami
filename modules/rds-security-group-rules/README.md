# RDS Security Group Rules Module
This folder contains a [Terraform](https://www.terraform.io/) module that defines the security group rules used by an [RDS instance](https://aws.amazon.com/rds/) configured for Fortify SSC to control the traffic that is allowed to go in and out of the instance.

## How do you use this module?
This folder defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your code by adding a `module` configuration and setting its `source` parameter to URL of this folder:

```
module "security_group_rules" {
  # Use version 1.1 of the jenkins-node-security-group-rules module
  source = "github.com/department-of-veterans-affairs/ascent-fortify-ami.git//modules/rds-security-group-rules?ref=v1.1"

  # The security group to associate the rule with
  security_group_id                             = "sg-abc123"

  # The security group that will be allowed access
  allowed_inbound_security_group_id             = "sg-xyz456"
}
```


Note the following parameter:
- `source`: Use this parameter to specify the URL of the jenkins-node-security-group-rules module. The double slash (//) is intentional and required. Terraform uses it to specify subfolders within a Git repo (see module sources). The ref parameter specifies a specific Git tag in this repo. That way, instead of using the latest version of this module from the master branch, which will change every time you run Terraform, you're using a fixed version of the repo.
- `security_group_id`: Use this parameter to tell the module which security group the rules need to be attached to.
- `allowed_inbound_security_group_id`: This parameter will be the security group ID that is allowed access to the RDS instance.
