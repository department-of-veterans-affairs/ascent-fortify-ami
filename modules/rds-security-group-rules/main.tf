###############################################################################
#
# Security group rule for rds service
#
###############################################################################

# Allow traffic from fortify instance security group
resource "aws_security_group_rule" "allow_tcp_inbound_from_fortify_security_group_id" {
  count                      = "${length(var.allowed_inbound_security_group_ids)}"
  type                       = "ingress"
  from_port                  = "${var.db_connection_port}"
  to_port                    = "${var.db_connection_port}"
  protocol                   = "tcp"
  source_security_group_id   = "${element(var.allowed_inbound_security_group_ids, count.index)}"
  security_group_id          = "${var.security_group_id}"
}
