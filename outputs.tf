// Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.

output "instance_id" {
  description = "ocid of created instances. "
  value       = ["${oci_core_instance.this.*.id}"]
}

output "private_ip" {
  description = "Private IPs of created instances. "
  value       = ["${oci_core_instance.this.*.private_ip}"]
}

output "public_ip" {
  description = "Public IPs of created instances. "
  value       = ["${oci_core_instance.this.*.public_ip}"]
}

output "volume_attachment_iqn" {
  description = "Unique IDs assigned to iSCSI devices. Used when attaching a volume to an instance. "
  value       = ["${oci_core_volume_attachment.this.*.iqn}"]
}

output "volume_attachment_ipv4" {
  description = "The volume's iSCSI IP addresses. "
  value       = ["${oci_core_volume_attachment.this.*.ipv4}"]
}

output "volume_attachment_port" {
  description = "The volume's iSCSI ports. "
  value       = ["${oci_core_volume_attachment.this.*.port}"]
}

output "instance_username" {
  description = "Usernames to login to Windows instance. "
  value       = ["${data.oci_core_instance_credentials.this.*.username}"]
}

output "instance_password" {
  description = "Passwords to login to Windows instance. "
  sensitive   = true
  value       = ["${data.oci_core_instance_credentials.this.*.password}"]
}
