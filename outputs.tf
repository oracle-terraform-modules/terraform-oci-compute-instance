// Copyright (c) 2018, 2021, Oracle and/or its affiliates.

locals {
  instances_details = [
    // display name, Primary VNIC Public/Private IP for each instance
    for i in oci_core_instance.this : <<EOT
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
  value       = oci_core_instance.this.*.id
}

output "private_ip" {
  description = "Private IPs of created instances. "
  value       = oci_core_instance.this.*.private_ip
}

output "public_ip" {
  description = "Public IPs of created instances. "
  value       = oci_core_instance.this.*.public_ip
}

output "instance_username" {
  description = "Usernames to login to Windows instance. "
  value       = data.oci_core_instance_credentials.this.*.username
}

output "instance_password" {
  description = "Passwords to login to Windows instance. "
  sensitive   = true
  value       = data.oci_core_instance_credentials.this.*.password
}

# New complete outputs for each resources with provider parity. Auto-updating.
# Usefull for module composition.

output "instance_all_attributes" {
  description = "all attributes of created instance"
  value       = { for k, v in oci_core_instance.this : k => v }
}

output "public_ip_all_attributes" {
  description = "all attributes of created public ip"
  value       = { for k, v in oci_core_public_ip.this : k => v }
}

output "private_ips_all_attributes" {
  description = "all attributes of created private ips"
  value       = { for k, v in data.oci_core_private_ips.this : k => v }
}

output "vnic_attachment_all_attributes" {
  description = "all attributes of created vnic attachments"
  value       = { for k, v in data.oci_core_vnic_attachments.this : k => v }
}

output "volume_all_attributes" {
  description = "all attributes of created volumes"
  value       = { for k, v in oci_core_volume.this : k => v }
}

output "volume_attachment_all_attributes" {
  description = "all attributes of created volumes attachments"
  value       = { for k, v in oci_core_volume_attachment.this : k => v }
}
