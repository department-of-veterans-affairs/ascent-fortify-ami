resource "aws_db_parameter_group" "fortify_parameter_group" {
  name     = "${var.name}"
  family   = "${var.family}"
  parameter {
    name           = "max_allowed_packet"
    value          = "${var.max_allowed_packet}"
    apply_method   = "pending-reboot"
  }

  parameter {
    name           = "innodb_log_file_size"
    value          = "${var.innodb_log_file_size}"
    apply_method   = "pending-reboot"
  }

  parameter {
    name           = "innodb_lock_wait_timeout"
    value          = "${var.innodb_lock_wait_timeout}"
    apply_method   = "pending-reboot"
  }

  parameter {
    name           = "query_cache_type"
    value          = "${var.query_cache_type}"
    apply_method   = "pending-reboot"
  }

  parameter {
    name           = "query_cache_size"
    value          = "${var.query_cache_size}"
    apply_method   = "pending-reboot"
  }

  parameter {
    name           = "innodb_buffer_pool_size"
    value          = "${var.innodb_buffer_pool_size}"
    apply_method   = "pending-reboot"
  }

  parameter {
    name           = "innodb_file_format"
    value          = "${var.innodb_file_format}"
    apply_method   = "pending-reboot"
  }

  parameter {
    name           = "innodb_large_prefix"
    value          = "${var.innodb_large_prefix}"
    apply_method   = "pending-reboot"
  }
}
