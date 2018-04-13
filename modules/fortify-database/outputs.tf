output "port" {
  value = "${aws_db_instance.fortify_database_instance.port}"
}

output "endpoint" {
  value = "${aws_db_instance.fortify_database_instance.endpoint}"
}
