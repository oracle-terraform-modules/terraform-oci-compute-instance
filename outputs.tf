// Copyright (c) 2018, 2021, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

output "instance_id" {
  description = "ocid of created instances. "
  value       = [oci_core_instance.this.*.id]
}

output "private_ip" {
  description = "Private IPs of created instances. "
  value       = [oci_core_instance.this.*.private_ip]
}

output "public_ip" {
  description = "Public IPs of created instances. "
  value       = [oci_core_instance.this.*.public_ip]
}

output "instance_username" {
  description = "Usernames to login to Windows instance. "
  value       = [data.oci_core_instance_credentials.this.*.username]
}

output "instance_password" {
  description = "Passwords to login to Windows instance. "
  sensitive   = true
  value       = [data.oci_core_instance_credentials.this.*.password]
}

