output "jenkins_fortify_node_ip" {
  value = "${aws_instance.jenkins_fortify_node.private_ip}"
}

output "security_group_id" {
  value = "${aws_security_group.fortify_security_group.id}"
}

output "ssh_port" {
  value = "${module.security_group_rules.ssh_port}"
}
