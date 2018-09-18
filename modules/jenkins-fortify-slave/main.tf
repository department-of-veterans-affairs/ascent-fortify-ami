# ---------------------------------------------------------------------------------------------------------------------
# THESE TEMPLATES REQUIRE TERRAFORM VERSION 0.8 AND ABOVE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.9.3"
}


# ---------------------------------------------------------------------------------------------------------------------
# Create the Fortify Jenkins Node instance
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "jenkins_fortify_node" {
  instance_type               = "${var.instance_type}"
  ami                         = "${var.ami_id}"
  key_name                    = "${var.ssh_key_name}"
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  vpc_security_group_ids      = ["${aws_security_group.fortify_security_group.id}"]
  user_data                   = "${var.user_data == "" ? data.template_file.fortify_user_data.rendered : var.user_data}"
  iam_instance_profile        = "${aws_iam_instance_profile.instance_profile.name}"
  tags {
      Name = "${var.instance_name}"
  }
  root_block_device {
    volume_size = "${var.disk_size}"
  }

  # -- Have the agent de-register itself from jenkins before it's destroyed, so that jenkins
  # -- won't error with 'agent already exists' when we try to recreate
  provisioner "local-exec" {
    when    = "destroy"
    command =  <<EOF
      API_TOKEN=$(curl -u ${var.jenkins_user}:${var.jenkins_password} ${var.jenkins_url}/me/configure | sed -rn 's/.*id="apiToken"[^>]*value="([a-z0-9]+)".*/\1/p')
      CRUMB=$(curl -s -u ${var.jenkins_user}:$${API_TOKEN} "${var.jenkins_url}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")
      curl -i -H $CRUMB -L -s -X POST -u ${var.jenkins_user}:$${API_TOKEN} ${var.jenkins_url}/computer/${var.agent-name}/doDelete
    EOF
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
  source = "../jenkins-node-security-group-rules"
  security_group_id                  = "${aws_security_group.fortify_security_group.id}"
  allowed_ssh_cidr_blocks        = ["${var.allowed_ssh_cidr_blocks}"]
  jenkins_master_security_group_id   = "${var.jenkins_master_security_group_id}"
  jenkins_master_http_port           = "${var.jenkins_master_http_port}"
}


# ---------------------------------------------------------------------------------------------------------------------
# Default User Data script
# ---------------------------------------------------------------------------------------------------------------------
data "template_file" "fortify_user_data" {
  template = "${file("${path.module}/fortify-user-data.sh")}"

  vars {
    jenkins_password            = "${var.jenkins_password}"
    jenkins_user                = "${var.jenkins_user}"
    jenkins_url                 = "${var.jenkins_url}"
    fortify_ssh_user            = "${var.fortify_ssh_user}"
    fortify_ssh_password        = "${var.fortify_ssh_password}"
    agent-name                  = "${var.agent-name}"
    agent-description           = "${var.agent-description}"
    agent-label-name            = "${var.agent-label-name}"
    credentials_id              = "${var.credentials_id}"
    vault_url                   = "${var.vault_url}"
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
  s3_bucket_name = "${var.fortify_bucket_name}"
}
