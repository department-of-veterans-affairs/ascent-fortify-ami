# S3 Bucket Policies To Role Module
This folder contains a [Terraform](https://www.terraform.io/) module contains the definition of policies for a role that you
attach to an EC2 Instance.

## What this module contains
This Module provides an 'all actions' access to a specified S3 bucket and everything under it.

## How do you use this module?
This folder defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your code by adding a `module` configuration and setting its `source` parameter to URL of this folder:

```
module "iam_s3_policies" {
  # Use version 1.1 of the s3-bucket-policies-to-role module
  source         = "github.com/department-of-veterans-affairs/ascent-fortify-ami.git//modules/s3-bucket-policies-to-role?ref=v1.1"

  # The ID of the IAM role to attach the policy to
  iam_role_id    = "ABCDEFGHIJ"

  # The name of the S3 bucket
  s3_bucket_name = "bucket-where-i-have-the-fortify-license-and-software"
}
```
