# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "fortify_db_username" {
  description = "The master username to use to authenticate the database"
}

variable "fortify_db_password" {
  description = "The master password to use to authenticate to the database"
}

variable "fortify_db_identifier" {
  description = "The name of the rds instance"
}

variable "fortify_subnet_ids" {
  description = "A list of VPC subnet IDs."
  type        = "list"
}

variable "vpc_id" {
  description = "The ID of the VPC in which to deploy the fortify instance"
}


variable "allowed_inbound_security_group_ids" {
  description = "The list of security group IDs that the Fortify instance uses, so the fortify instance will be allowed"
  type        = "list"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "root_db_name" {
  description = "The name of the database first created by rds"
  default     = "rootdb"
}

variable "mysql_version" {
  description = "The version of the mysql engine"
  default     = "5.6"
}


