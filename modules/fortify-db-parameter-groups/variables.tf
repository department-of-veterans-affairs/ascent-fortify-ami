#-------------------------------------------------------------------------------------------------
#  REQUIRED VARIABLES FOR MYSQL PARAMETER GROUP
#-------------------------------------------------------------------------------------------------
variable "name" {
  description = "Name of the parameter group"
}

variable "family" {
  description = "Name of the family for the parameter group"
}


#-------------------------------------------------------------------------------------------------
#  OPTIONAL VARIABLES FOR MYSQL CONFIGURATIONS 
#      SEE Fortify-Software-Security-Center-User-Guide for 17.20 
#      for more details
#-------------------------------------------------------------------------------------------------
variable "max_allowed_packet" {
  # equivalent to suggested size for fortify(1G)
  default   = "1073741824"
}

variable "innodb_log_file_size" { 
  # equivalent to suggested size for fortify(3G)
  default   = "3221225472" 
}

variable "innodb_lock_wait_timeout" {
  default   = "300" 
}

variable "query_cache_type" {
  default   = "1" 
}

variable "query_cache_size" {
  # equivalent to suggested size for fortify (7OM)
  default   = "73400320" 
}

variable "innodb_buffer_pool_size" {
  # equivalent to suggested size for fortify (10GB)
  default   = "10737418240" 
}

variable "innodb_file_format" {
  default   = "Barracuda"
}

variable "innodb_large_prefix" {
  default   = "1"
}

