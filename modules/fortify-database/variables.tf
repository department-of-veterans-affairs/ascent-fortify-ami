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

variable "allowed_inbound_cidr_blocks" {
  description = "The subnet IDs into which the EC2 instances should be deployed"
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

variable "allowed_ssh_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow SSH connections"
  type        = "list"
  default     = []
}


variable "allowed_inbound_security_group_ids" {
  description = "A list of security group IDs that will be allowed to connect to Fortify"
  type        = "list"
  default     = []
}

variable "fortify_port" {
  description = "The port used to reach the database"
  default     = 3306
}


