###############################################################################
# REQUIRED VARIABLES
###############################################################################
variable "allowed_ssh_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow connection to Fortify"
  type        = "list"
}
variable "security_group_id" {
  description = "The ID of the security group to which we should add the Fortify security group rules"
}


###############################################################################
# OPTIONAL VARIABLES
###############################################################################
variable "ssh_port" {
  description = "The port for ssh connections. Usually port 22"
  default     = 22
}
