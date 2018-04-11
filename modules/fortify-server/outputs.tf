output "security_group_id" {
  value = "${aws_security_group.fortify_security_group.id}"
}

output "fortify_private_ip" {
  value = "${aws_instance.fortify.private_ip}"
}
