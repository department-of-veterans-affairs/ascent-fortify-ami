###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "security_group_id" {
  description = "The ID of the security group to which we should add the Fortify security group rules"
}

variable "allowed_inbound_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow connections to Fortify"
  type        = "list"
}

variable "allowed_ssh_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow connection to Fortify"
  type        = "list"
}

###############################################################################
# OPTIONAL VARIABLES
###############################################################################

variable "allowed_inbound_security_group_ids" {
  description = "A list of security group IDs that will be allowed to connect to Fortify"
  type        = "list" 
  default     = []
}

variable "fortify_http_port" {
  description = "The port used to resolve Fortify connections"
  default     = 8080
}


variable "ssh_port" {
  description = "The port used to resolve SSH connections"
  default     = 22
}
