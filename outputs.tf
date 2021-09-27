# Copyright (c) 2018, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  instances_details = [
    // display name, Primary VNIC Public/Private IP for each instance
    for i in oci_core_instance.instance : <<EOT
    ${~i.display_name~}
    Primary-PublicIP: %{if i.public_ip != ""}${i.public_ip~}%{else}N/A%{endif~}
    Primary-PrivateIP: ${i.private_ip~}
    EOT
  ]
}

output "instances_summary" {
  description = "Private and Public IPs for each instance."
  value       = local.instances_details
}

output "instance_id" {
  description = "ocid of created instances. "
  value       = oci_core_instance.instance.*.id
}

output "private_ip" {
  description = "Private IPs of created instances. "
  value       = oci_core_instance.instance.*.private_ip
}

output "public_ip" {
  description = "Public IPs of created instances. "
  value       = oci_core_instance.instance.*.public_ip
}

output "instance_username" {
  description = "Usernames to login to Windows instance. "
  value       = data.oci_core_instance_credentials.credential.*.username
}

output "instance_password" {
  description = "Passwords to login to Windows instance. "
  sensitive   = true
  value       = data.oci_core_instance_credentials.credential.*.password
}

# New complete outputs for each resources with provider parity. Auto-updating.
# Usefull for module composition.

output "instance_all_attributes" {
  description = "all attributes of created instance"
  value       = { for k, v in oci_core_instance.instance : k => v }
}

output "public_ip_all_attributes" {
  description = "all attributes of created public ip"
  value       = { for k, v in oci_core_public_ip.public_ip : k => v }
}

output "private_ips_all_attributes" {
  description = "all attributes of created private ips"
  value       = { for k, v in data.oci_core_private_ips.private_ips : k => v }
}

output "vnic_attachment_all_attributes" {
  description = "all attributes of created vnic attachments"
  value       = { for k, v in data.oci_core_vnic_attachments.vnic_attachment : k => v }
}

output "volume_all_attributes" {
  description = "all attributes of created volumes"
  value       = { for k, v in oci_core_volume.volume : k => v }
}

output "volume_attachment_all_attributes" {
  description = "all attributes of created volumes attachments"
  value       = { for k, v in oci_core_volume_attachment.volume_attachment : k => v }
}
