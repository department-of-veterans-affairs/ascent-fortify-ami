# ---------------------------------------------------------------------------------------------------------------------
variable "fortify_ssh_port" {
  description = "The port used to resolve ssh for Fortify instance connections"
  default     = 22
}
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
  fortify_http_port        = "${var.fortify_http_port}"
}


# ---------------------------------------------------------------------------------------------------------------------
# Default User Data script
# ---------------------------------------------------------------------------------------------------------------------

data "template_file" "fortify_user_data" {
  template = "${file("${path.module}/fortify-user-data.sh")}"

  vars {
    fortify_ip           = ""
  }
}
