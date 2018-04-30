output "jenkins_fortify_node_ip" {
  value = "${aws_instance.jenkins_fortify_node.private_ip}"
}
