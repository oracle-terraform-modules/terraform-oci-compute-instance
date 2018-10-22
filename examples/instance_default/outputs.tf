// Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.

output "instance_id" {
  description = "ocid of created instances. "
  value       = ["${module.instance.instance_id}"]
}

output "private_ip" {
  description = "Private IPs of created instances. "
  value       = ["${module.instance.private_ip}"]
}

output "public_ip" {
  description = "Public IPs of created instances. "
  value       = ["${module.instance.public_ip}"]
}

output "volume_attachment_iqn" {
  description = "Unique IDs assigned to iSCSI devices. Used when attaching a volume to an instance. "
  value       = ["${module.instance.volume_attachment_iqn}"]
}

output "volume_attachment_port" {
  description = "The volume's iSCSI ports. "
  value       = ["${module.instance.volume_attachment_port}"]
}

output "volume_attachment_ipv4" {
  description = "The volume's iSCSI IP addresses. "
  value       = ["${module.instance.volume_attachment_ipv4}"]
}

output "instance_username" {
  description = "Usernames to login to Windows instance. "
  value       = ["${module.instance.instance_username}"]
}

output "instance_password" {
  description = "Passwords to login to Windows instance. "
  sensitive   = true
  value       = ["${module.instance.instance_password}"]
}
