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

variable "jenkins_master_security_group_id" {
  description = "The ID of the Jenkins master instance that will allow http and ssh access to this agent"
}

###############################################################################
# OPTIONAL VARIABLES
###############################################################################
variable "jenkins_master_http_port" {
  description = "The Jenkins Master port that we need to open up to allow the foritfy agent HTTP access"
  default     = "8080"
}

variable "ssh_port" {
  description = "The port for ssh connections. Usually port 22"
  default     = 22
}
