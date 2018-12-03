// Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.

variable "compartment_ocid" {
  description = "Compartment's OCID where VCN will be created. "
}

variable "instance_display_name" {
  description = "Name of Instance. "
  default     = ""
}

variable "extended_metadata" {
  description = "Additional metadata key/value pairs that you provide. "
  default     = {}
}

variable "ipxe_script" {
  description = "The iPXE script which to continue the boot process on the instance. "
  default     = ""
}

variable "preserve_boot_volume" {
  description = "Specifies whether to delete or preserve the boot volume when terminating an instance. "
  default     = false
}

variable "boot_volume_size_in_gbs" {
  description = "The size of the boot volume in GBs. "
  default     = "50"
}

variable "shape" {
  description = "The shape of an instance. "
  default     = "VM.Standard2.1"
}

variable "assign_public_ip" {
  description = "Whether the VNIC should be assigned a public IP address. "
  default     = false
}

variable "vnic_name" {
  description = "A user-friendly name for the VNIC. "
  default     = ""
}

variable "hostname_label" {
  description = "The hostname for the VNIC's primary private IP. "
  default     = ""
}

variable "private_ips" {
  description = "Private IP addresses of your choice to assign to the VNICs. "
  type        = "list"
  default     = []
}

variable "skip_source_dest_check" {
  description = "Whether the source/destination check is disabled on the VNIC. "
  default     = false
}

variable "subnet_ocids" {
  description = "The unique identifiers (OCIDs) of the subnets in which the instance primary VNICs are created. "
  type        = "list"
}

variable "ssh_authorized_keys" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance. "
}

variable "user_data" {
  description = "Provide your own base64-encoded data to be used by Cloud-Init to run custom scripts or provide custom Cloud-Init configuration. "
  default     = ""
}

variable "source_ocid" {
  description = "The OCID of an image or a boot volume to use, depending on the value of source_type. "
}

variable "source_type" {
  description = "The source type for the instance. "
  default     = "image"
}

variable "instance_timeout" {
  description = "Timeout setting for creating instance. "
  default     = "25m"
}

variable "instance_count" {
  description = "Number of instances to launch. "
  default     = "1"
}

variable "block_storage_sizes_in_gbs" {
  description = "Sizes of volumes to create and attach to each instance. "
  default     = []
}

variable "attachment_type" {
  description = "Attachment type. "
  default     = "iscsi"
}

variable "use_chap" {
  description = "Whether to use CHAP authentication for the volume attachment. "
  default     = false
}

variable "resource_platform" {
  description = "Platform to create resources in. "
  default     = "linux"
}