###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "security_group_id" {
  description = "The ID of the fortify instance security group to which we will allow access"
}

variable "allowed_inbound_security_group_ids" {
  description = "A list of security group IDs that will be allowed to connect to Fortify"
  type        = "list" 
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "db_connection_port" {
  description = "The port for db connections"
  default     = "3306"
}
