###############################################################################
#
# Security group rule for the jenkins fortify node
#
###############################################################################

resource "aws_security_group_rule" "allow_ssh_inbound" {
  count       = "${length(var.allowed_ssh_cidr_blocks) >= 1 ? 1 : 0}"
  type        = "ingress"
  from_port   = "${var.ssh_port}"
  to_port     = "${var.ssh_port}"
  protocol    = "tcp"
  cidr_blocks = ["${var.allowed_ssh_cidr_blocks}"]

  security_group_id = "${var.security_group_id}"
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${var.security_group_id}"
}


# Add a rule to allow the fortify agent to make jenkins api calls
resource "aws_security_group_rule" "allow_fortify_agent_inbound" {
  type       = "ingress"
  from_port  = "${var.jenkins_master_http_port}"
  to_port    = "${var.jenkins_master_http_port}"
  protocol   = "tcp"
  source_security_group_id = "${var.security_group_id}"
  security_group_id        = "${var.jenkins_master_security_group_id}"
}


# Add a rule to allow the fortify agent have a slave connection to the jenkins master
resource "aws_security_group_rule" "allow_fortify_agent_ssh_inbound" {
  type       = "ingress"
  from_port  = "${var.ssh_port}"
  to_port    = "${var.ssh_port}"
  protocol   = "tcp"
  source_security_group_id = "${var.security_group_id}"
  security_group_id        = "${var.jenkins_master_security_group_id}"
}

