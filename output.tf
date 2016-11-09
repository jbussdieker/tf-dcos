// URL to access the Exhibitor UI
output "exhibitor_url" {
  value = "http://${element(aws_instance.master.*.public_ip, 0)}:8181"
}

// URL to access the DC/OS UI
output "dcos_url" {
  value = "http://${element(aws_instance.master.*.public_ip, 0)}"
}
