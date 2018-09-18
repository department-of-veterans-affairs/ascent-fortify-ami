# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "instance_name" {
  description = "The name of the jenkins slave instance"
}

variable "ami_id" {
  description = "The ID of the AMI to run."
}

variable "instance_type" {
  description = "The type of EC2 Instances to run for the fortify instance (e.g. m4.large)"
}

variable "subnet_id" {
  description = "The subnet IDs into which the EC2 instances should be deployed."
}

variable "vpc_id" {
  description = "The ID of the VPC in which to deploy the fortify instance"
}

variable "jenkins_password" {
  description = "The password to the jenkins instance with which to perform configurations"
}

variable "jenkins_user" {
  description = "The name of the user that will authenticat to jenkins for configuration as a jenkins slave"
}

variable "fortify_ssh_user" {
  description = "The user that jenkins will use to authenticate over ssh with the fortify agent"
}

variable "fortify_ssh_password" {
  description = "The password that jenkins will use to authenticate over ssh with the fortify agent"
}

variable "jenkins_master_security_group_id" {
  description = "The security group ID of the Jenkins Master Instance, so we can grant the fortify agent access to some of its ports"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "jenkins_master_http_port" {
  description = "The HTTP port of the jenkins master instance. Usually 8080"
  default     = "8080"
}


variable "fortify_bucket_name" {
  description = "The name of the bucket that holds the fortify software and license"
  default      = "fortify-utility"
}


variable "ssh_key_name" {
  description  = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instance. Set to an empty string to not associate a key pair"
  default      = ""
}


variable "jenkins_url" {
  description = "The url of the jenkins instance (e.g. http://your.jenkins.server.name:8080)"
  default     = "http://jenkins.internal.vets-api.gov:8080"
}

variable "vault_url" {
  description = "The url of the vault server"
  default     = "https://vault.internal.vets-api.gov:8200"
}

variable "agent-name" {
  description = "The name of the jenkins agent/node/slave"
  default     = "fortify-sca"
}

variable "agent-description" {
  description = "The description of the jenkins agent/node/slave"
  default     = "Runs all fortify-sca scans"
}

variable "agent-label-name" {
  description = "The label of the agent/slave/node to refer to it with from other jobs"
  default     = "fortify-sca"
}

variable "credentials_id" {
  description = "The id of the credentials to authenticate the jenkins server to the agent with. We're assuming here that the credentials have already been set up through packer for jenkins."
  default     = "fortify"
}

variable "instance_profile_path" {
  description = "Path in which to create the IAM instance profile"
  default     = "/"
}

variable "user_data" {
  description = "A User data script to execute while the server is booting."
  default     = ""
}

variable "associate_public_ip_address" {
  description = "If set to true, associate a public IP address with the Fortify instance"
  default     = false
}

variable "allowed_ssh_cidr_blocks" {
  description = "The cidr block(s) allowed to connected through ssh"
  default     = ["0.0.0.0/0"]
}

variable "disk_size" {
  description = "Size of the root block device. Defaults to 500GB"
  default     = 500
}