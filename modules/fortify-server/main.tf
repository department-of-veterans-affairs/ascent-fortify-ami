# ---------------------------------------------------------------------------------------------------------------------
# THESE TEMPLATES REQUIRE TERRAFORM VERSION 0.8 AND ABOVE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.9.3"
}


# ---------------------------------------------------------------------------------------------------------------------
# Create the Fortify instance
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "fortify" {
  instance_type               = "${var.instance_type}"
  ami                         = "${var.ami_id}"
  key_name                    = "${var.ssh_key_name}"
  subnet_id                   = "${var.subnet_ids[length(var.subnet_ids) - 1]}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  vpc_security_group_ids      = ["${aws_security_group.fortify_security_group.id}"]
  user_data                   = "${var.user_data == "" ? data.template_file.fortify_user_data.rendered : var.user_data}"
  iam_instance_profile        = "${aws_iam_instance_profile.instance_profile.name}"
  tags {
      Name = "${var.instance_name}"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# Control Traffic to Fortify instances
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "fortify_security_group" {
  name_prefix = "${var.instance_name}"
  description = "Security group for the ${var.instance_name} instances"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "${var.instance_name}"
  }
}

module "security_group_rules" {
  source = "../fortify-security-group-rules"

  security_group_id                  = "${aws_security_group.fortify_security_group.id}"
  allowed_inbound_cidr_blocks        = ["${var.allowed_inbound_cidr_blocks}"]
  allowed_inbound_security_group_ids = ["${var.allowed_inbound_security_group_ids}"]
  allowed_ssh_cidr_blocks            = ["${var.allowed_ssh_cidr_blocks}"]
  fortify_port                       = "${var.fortify_http_port}"
}


# ---------------------------------------------------------------------------------------------------------------------
# Default User Data script
# ---------------------------------------------------------------------------------------------------------------------
data "template_file" "fortify_user_data" {
  template = "${file("${path.module}/fortify-user-data.sh")}"

  vars {
    fortify_jdbc_url            = "jdbc:mysql://${module.fortify-database.endpoint}/${var.fortify_db_name}"
    fortify_db_name             = "${var.fortify_db_name}"
    root_db_name                = "${var.root_db_name}"
    fortify_db_endpoint         = "${module.fortify-database.endpoint}"
    fortify_db_username         = "${var.fortify_db_username}"
    fortify_db_password         = "${var.fortify_db_password}"
    fortify_db_driver_class     = "${var.fortify_db_driver_class}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ATTACH AN IAM ROLE TO THE FORTIFY INSTANCE
# We can use an IAM role to grant the instance IAM permissions so we can use the AWS CLI without having to figure out
# how to get our secret AWS access keys onto the box.
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_instance_profile" "instance_profile" {
  name_prefix  = "${var.instance_name}"
  path         = "${var.instance_profile_path}"
  role         = "${aws_iam_role.instance_role.name}"
}

resource "aws_iam_role" "instance_role" {
  name_prefix        = "${var.instance_name}"
  assume_role_policy = "${data.aws_iam_policy_document.instance_role.json}"
}

data "aws_iam_policy_document" "instance_role" {
  statement {
    effect   = "Allow"
    actions  = ["sts:AssumeRole"]

    principals {
      type           = "Service"
      identifiers    = ["ec2.amazonaws.com"]
    }
  }
}

module "iam_s3_policies" {
  source         = "../s3-bucket-policies-to-role"
  iam_role_id    = "${aws_iam_role.instance_role.id}"
  s3_bucket_name = "ascent-fortify"
}



# ---------------------------------------------------------------------------------------------------------------------
# The Database for Fortify to Use
# ---------------------------------------------------------------------------------------------------------------------

module "fortify-database" {
  source                               = "../fortify-database"
  fortify_db_username                  = "${var.fortify_db_username}"
  fortify_db_password                  = "${var.fortify_db_password}"
  root_db_name                         = "${var.root_db_name}"
  fortify_db_identifier                = "${var.instance_name}-database"
  fortify_subnet_ids                   = ["${var.subnet_ids}"]
  allowed_inbound_security_group_id    = "${aws_security_group.fortify_security_group.id}"
  vpc_id                               = "${var.vpc_id}"
}
